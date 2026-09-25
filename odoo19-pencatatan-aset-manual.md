# Pencatatan Aset Manual di Odoo 19

Berlaku untuk: Odoo 19 Enterprise, modul **Assets** (`account_asset`).

Pertanyaan yang dijawab: jika aset dibuat secara manual di Odoo, apakah perlu membuat jurnal pengakuan aset (Aset di debet, Kas/Bank di kredit) terlebih dahulu?

---

## 1. Kesimpulan

**Ya, jurnal perolehan aset harus dicatat sendiri.** Modul `account_asset` tidak pernah membuat jurnal perolehan (Aset di debet, Kas/Bank/Hutang di kredit). Modul ini hanya membuat:

- jurnal **penyusutan** setiap periode, dan
- jurnal **pelepasan atau penjualan** saat aset di-dispose atau dijual.

Untuk pembelian aset baru, catat dulu jurnal perolehannya (Vendor Bill, Journal Entry, atau transaksi bank), lalu hubungkan jurnal itu ke aset.

Pengecualiannya hanya satu: **aset lama atau saldo awal migrasi**. Di sini nilai perolehannya sudah tercatat di jurnal saldo awal, jadi aset boleh dibuat manual tanpa jurnal perolehan baru.

---

## 2. Dasar dari source code

Semua path di bawah ini relatif terhadap folder modul `account_asset`.

### 2.1 Tombol Confirm hanya membuat jurnal penyusutan

`models/account_asset.py`, method `validate()`:

```python
def validate(self):
    ...
    self.write({'state': 'open'})
    for asset in self:
        ...
        if not asset.depreciation_move_ids:
            asset.compute_depreciation_board()
        asset._check_depreciations()
        asset.depreciation_move_ids.filtered(lambda move: move.state != 'posted')._post()
```

Method ini hanya mengubah status aset menjadi *Running* (`open`), membuat jadwal penyusutan, lalu mem-posting jurnal penyusutan. Tidak ada jurnal perolehan yang dibuat.

### 2.2 Jurnal penyusutan hanya memakai akun akumulasi dan akun beban

`models/account_move.py`, method `_prepare_move_for_asset_depreciation()`:

| Baris | Akun | Debet | Kredit |
|---|---|:---:|:---:|
| `move_line_1` | `account_depreciation_id` (Akumulasi Penyusutan) | | ✔ |
| `move_line_2` | `account_depreciation_expense_id` (Beban Penyusutan) | ✔ | |

Akun aset tetap (`account_asset_id`) dan akun kas/bank tidak dipakai.

### 2.3 Saat disposal, akun aset di-kredit sebesar nilai perolehan

`models/account_asset.py`, method `_get_disposal_moves()`:

```python
initial_amount = asset.original_value
initial_account = asset.original_move_line_ids.account_id if len(asset.original_move_line_ids.account_id) == 1 else asset.account_asset_id
...
line_datas = [(initial_amount, initial_account), (depreciated_amount, depreciation_account)] + ...
```

Saat aset dilepas, Odoo mengeluarkan nilai perolehan dari akun aset dengan mengkredit akun tersebut sebesar `original_value`. Jika sejak awal akun aset tidak pernah didebet, saldonya di buku besar akan menjadi minus.

### 2.4 Aset dibuat otomatis saat jurnal di-posting

`models/account_move.py`:

- `_post()` memanggil `_auto_create_asset()` setiap kali jurnal di-posting.
- `_auto_create_asset()` membuat aset dari baris jurnal yang akunnya memenuhi `can_create_asset = True` dan `create_asset != 'no'`.

`models/account.py`:

- `can_create_asset` hanya bernilai `True` untuk akun bertipe `asset_fixed` (*Fixed Assets*) atau `asset_non_current` (*Non-current Assets*).
- `create_asset` punya tiga pilihan: `no` (*No*), `draft` (*Create in draft*), dan `validate` (*Create and validate*).

---

## 3. Akibat jika aset dibuat manual tanpa jurnal perolehan

| Kondisi | Akibat di laporan |
|---|---|
| Aset berjalan | Akumulasi penyusutan dan beban penyusutan tercatat, tetapi nilai perolehan aset tidak muncul di neraca. Nilai buku aset di neraca menjadi negatif. |
| Kas/Bank | Pengeluaran untuk pembelian aset tidak tercatat, sehingga saldo kas/bank di Odoo tidak sesuai dengan rekening koran. |
| Aset di-dispose atau dijual | Akun aset di-kredit sebesar `original_value`, sehingga saldo akun aset menjadi minus. |

---

## 4. Alur yang benar

### 4.1 Pembelian aset baru, aset dibuat otomatis (disarankan)

1. Buka **Accounting → Configuration → Chart of Accounts**, lalu buka akun aset tetap (tipe *Fixed Assets* atau *Non-current Assets*).
2. Di tab **Automation**, isi field **Automate Asset**:
   - **Create in draft**: aset dibuat berstatus draft agar bisa dicek dulu sebelum di-Confirm.
   - **Create and validate**: aset langsung dibuat dan berjalan.

   Isi juga **Asset Model** jika ingin metode penyusutan, durasi, dan akun penyusutan terisi otomatis.
3. Catat pembeliannya lewat **Vendor Bill**, **Journal Entry**, atau rekonsiliasi bank, dengan baris debet ke akun aset tersebut.
4. Posting jurnalnya. Aset akan terbentuk otomatis dan sudah terhubung ke baris jurnal pembelian.

Contoh jurnal pembelian tunai, laptop seharga Rp 15.000.000:

| Akun | Debet | Kredit |
|---|---:|---:|
| Aset Tetap – Peralatan Kantor | 15.000.000 | |
| Kas/Bank | | 15.000.000 |

Contoh jurnal pembelian kredit lewat Vendor Bill:

| Akun | Debet | Kredit |
|---|---:|---:|
| Aset Tetap – Peralatan Kantor | 15.000.000 | |
| Hutang Usaha | | 15.000.000 |

Pelunasan hutangnya dicatat terpisah (Hutang Usaha di debet, Kas/Bank di kredit).

### 4.2 Pembelian aset baru, aset dibuat manual lalu dihubungkan ke jurnal

1. Catat dan posting jurnal pembelian seperti contoh di 4.1.
2. Buat aset baru di menu **Accounting → Accounting → Assets**.
3. Di tab **Bills** (field `original_move_line_ids`), tambahkan baris jurnal pembelian tadi. Baris yang bisa dipilih harus memenuhi semua syarat berikut:
   - jurnalnya sudah **posted**,
   - akunnya bertipe *Fixed Assets*, *Non-current Assets*, atau *Current Assets*,
   - jurnalnya berupa Vendor Bill, Refund, Receipt, atau Journal Entry,
   - baris tersebut bukan bagian dari jurnal penyusutan aset lain.
4. Setelah baris dihubungkan, field berikut terisi otomatis dari jurnal:
   - **Original Value** (`original_value`),
   - **Acquisition Date** (`acquisition_date`),
   - **Fixed Asset Account** (`account_asset_id`), jika semua baris memakai akun yang sama,
   - nama aset, jika masih kosong.
5. Lengkapi metode penyusutan, lalu klik **Confirm**.

Jika **Original Value** diubah manual sehingga berbeda dari nilai jurnal, Odoo akan menampilkan peringatan.

### 4.3 Aset lama atau saldo awal migrasi (tanpa jurnal perolehan baru)

Alur ini hanya dipakai jika nilai perolehan dan akumulasi penyusutan sudah tercatat di jurnal saldo awal (*opening balance*).

1. Buat aset manual di menu **Accounting → Accounting → Assets**, tanpa mengisi tab **Bills**.
2. Isi field berikut:
   - **Original Value**: nilai perolehan,
   - **Acquisition Date**: tanggal perolehan sebenarnya,
   - **Fixed Asset Account**: akun aset yang sama dengan yang dipakai di jurnal saldo awal,
   - metode, durasi, **Depreciation Account**, dan **Expense Account**,
   - **Depreciated Amount** (`already_depreciated_amount_import`): akumulasi penyusutan yang sudah tercatat sampai tanggal saldo awal.
3. Klik **Confirm**. Odoo hanya membuat jurnal penyusutan untuk sisa periode, tanpa mengulang penyusutan yang sudah tercatat di saldo awal.

Contoh jurnal saldo awal (dibuat sekali, di luar modul aset):

| Akun | Debet | Kredit |
|---|---:|---:|
| Aset Tetap – Kendaraan | 200.000.000 | |
| Akumulasi Penyusutan – Kendaraan | | 80.000.000 |
| Ekuitas Saldo Awal | | 120.000.000 |

Isian di aset: **Original Value** = 200.000.000 dan **Depreciated Amount** = 80.000.000.

---

## 5. Ringkasan

| Situasi | Perlu jurnal perolehan? | Cara |
|---|---|---|
| Beli aset baru, aset dibuat otomatis | Ya, lewat Vendor Bill atau Journal Entry | Atur **Automate Asset** di akun (4.1) |
| Beli aset baru, aset dibuat manual | Ya, dicatat lebih dulu | Hubungkan lewat tab **Bills** (4.2) |
| Aset lama atau migrasi saldo awal | Tidak, sudah ada di saldo awal | Isi **Depreciated Amount** (4.3) |
| Aset dibuat manual tanpa jurnal perolehan sama sekali | Tidak boleh | Nilai aset di neraca salah dan akun aset menjadi minus saat disposal |
