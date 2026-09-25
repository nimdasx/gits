# Odoo 19: Opening Balance & Mekanisme Tutup Buku (Year-End Closing)

Panduan ringkas, jelas, dan padat mengenai perlakuan saldo awal (*opening balance*) serta alur penutupan buku tahunan di Odoo 19.

---

## 1. Opening Balance: Apakah Hanya Akun Neraca?

**Ya, idealnya HANYA akun Neraca (Balance Sheet). Akun Laba Rugi (Profit & Loss) tidak perlu diimpor.**

### Mengapa?
* **Akun Neraca (*Akun Riil*):** Bersifat akumulatif (*carried forward*) dari tahun ke tahun (Kas/Bank, Piutang, Hutang, Modal).
* **Akun Laba Rugi (*Akun Nominal*):** Bersifat temporer dan saldonya otomatis di-reset ke **0** setiap pergantian tahun buku, di mana net laba/ruginya ditampung ke Ekuitas (**Laba Ditahan / Retained Earnings**).

### Skenario Berdasarkan Waktu Cut-Off
1. **Cut-off Awal Tahun (misal: per 31 Des / 1 Jan):**
   * **100% hanya akun Neraca.** Saldo akun Laba Rugi tahun sebelumnya sudah otomatis melebur ke akun *Retained Earnings*.
2. **Cut-off Tengah Tahun (Mid-Year Go-Live, misal: per 30 Juni / 1 Juli):**
   * **Opsi Terbaik (*Best Practice*):** Tetap hanya akun Neraca. Laba/rugi bersih berjalan (Januari - Juni) digabung dan dimasukkan ke satu akun ekuitas: **Laba Tahun Berjalan (*Current Year Earnings*)**.
   * **Opsi Alternatif (Jika manajemen wajib laporan YTD):** Impor rekap akun Laba Rugi periode berjalan (Year-to-Date). *Catatan:* Jangan lagi mencatat laba berjalan ke ekuitas secara manual agar tidak terjadi *double-counting*.

---

## 2. Mekanisme Tutup Buku di Odoo (31 Desember)

Di Odoo **TIDAK PERLU** membuat jurnal penutup manual untuk me-nol-kan (*zeroing out*) akun pendapatan dan beban.

### Cara Kerja Odoo
* Laporan keuangan Odoo bersifat **dinamis berbasis filter tanggal**.
* Saat memasuki tahun fiskal baru (misal: 2028), filter tanggal baru otomatis menampilkan saldo akun Laba Rugi mulai dari **0**.
* Laba/rugi bersih otomatis dihitung sistem dan ditampilkan dinamis pada:
  * **Neraca (*Balance Sheet*):** Baris **`Current Year Unallocated Earnings`** (laba tahun berjalan) dan **`Previous Years Earnings`** (akumulasi laba tahun-tahun sebelumnya).
  * **Neraca Saldo & Buku Besar (*Trial Balance & General Ledger*):** Baris **`Result Brought Forward`**.
  * Akun penampung sistem di Chart of Accounts (CoA) bertipe `equity_unaffected` (default Indonesia: `999999 Undistributed Profits/Losses`).

> ⚠️ **Peringatan:** Jangan membuat jurnal pembalik/me-nol-kan pendapatan & beban di akhir tahun, karena justru akan membuat laporan Laba Rugi tahun tersebut menjadi Rp 0.

---

## 3. Bentuk Jurnal Tutup Buku di Odoo

Satu-satunya jurnal akhir tahun terkait laba/rugi di Odoo adalah **Jurnal Alokasi Hasil Usaha (Reklasifikasi Ekuitas)** untuk memindahkan laba dari akun penampung sistem ke akun ekuitas resmi (Laba Ditahan / Cadangan / Dividen).

*Contoh Kasus:* Laba bersih tahun 2027 sebesar **Rp 300.000.000**.

### Jurnal Alokasi Laba Bersih
* **Jurnal:** Miscellaneous Operations
* **Tanggal:** **31 Desember 2027** *(Wajib akhir tahun buku terkait, jangan 1 Januari)*
* **Keterangan:** Alokasi Laba Bersih Tahun Fiskal 2027 ke Laba Ditahan

| Akun | Posisi | Nominal |
| :--- | :---: | :---: |
| `999999 Undistributed Profits/Losses` | **Debet** | Rp 300.000.000 |
| `320000 Retained Earnings (Laba Ditahan)` | **Kredit** | Rp 300.000.000 |

*(Jika rugi, posisi akun dibalik: Debet Laba Ditahan, Kredit Undistributed Profits).*

> 💡 **Penting mengenai Tanggal:** Jurnal alokasi harus bertanggal **31 Desember 2027** (bukan 1 Januari 2028). Di Odoo, akun `equity_unaffected` dihitung per tahun fiskal berjalan. Jika dialokasikan pada 1 Januari 2028, entri tersebut akan memotong laba tahun berjalan 2028.

---

## 4. Tiga Langkah Tutup Buku Akhir Tahun di Odoo

1. **Jurnal Penyesuaian Akhir Tahun (*Year-End Adjustments*):**
   * Depresiasi & amortisasi aset tetap per 31 Desember.
   * Jurnal akrual (beban yang masih harus dibayar / pendapatan diterima di muka).
   * Penyesuaian selisih kurs akhir tahun (*Unrealized FX Gain/Loss*).
   * Penyesuaian nilai persediaan (*Stock Opname*).
2. **Jurnal Alokasi Hasil Usaha (Opsional / Sesuai RUPS):**
   * Memindahkan saldo laba dari akun penampung sistem (`equity_unaffected`) ke Laba Ditahan, Cadangan, atau Hutang Dividen.
3. **Kunci Periode (*Lock Date*) — Langkah Wajib & Krusial:**
   * Akses menu: **Accounting > Closing > Lock Dates…**
   * Odoo 19 menyediakan 2 level penguncian:
     1. **Lock Everything (`fiscalyear_lock_date`):**
        * Mengunci seluruh jurnal hingga tanggal `31/12/2027`.
        * Masih memungkinkan pembukaan dispensasi sementara (*Lock Exception*) oleh Administrator (misal: 15 menit, 1 jam, 24 jam) jika ada koreksi darurat berizin.
     2. **Hard Lock (`hard_lock_date`):**
        * Penguncian permanen dan mutlak (*irreversible*).
        * Tanggal tidak bisa dimundurkan atau dihapus, dan tidak mengizinkan dispensasi (*exception*) apapun demi kepatuhan audit inalterabilitas data.
        * Syarat: Seluruh entri *draft* pada periode tersebut harus sudah di-post atau dihapus terlebih dahulu.

---

## 5. Bukti & Referensi Source Code (Odoo 19 Enterprise & Core)

Seluruh mekanisme di atas telah divalidasi langsung terhadap *source code* Odoo 19:

### A. Bukti Saldo Awal Tidak Membawa Akun Laba Rugi
* **File:** `odoo/addons/account/models/account_account.py`
  ```python
  @api.depends('account_type')
  def _compute_include_initial_balance(self):
      for account in self:
          account.include_initial_balance = (
              account.internal_group not in ['income', 'expense'] 
              and account.account_type != 'equity_unaffected'
          )
  ```
  *Penjelasan:* Akun bertipe `income`, `expense`, dan `equity_unaffected` secara otomatis bernilai `include_initial_balance = False`, sehingga saldo awalnya selalu 0 di awal tahun buku baru.

### B. Bukti Perhitungan Dinamis di Neraca & Laba Rugi
* **File:** `enterprise/account_reports/data/balance_sheet.xml`
  * Baris **`Current Year Unallocated Earnings` (CYE):** Menghitung laba berjalan secara dinamis menggunakan ekspresi:
    `[('account_id.account_type', 'in', ['income', 'income_other', 'expense_direct_cost', 'expense', 'expense_depreciation', 'expense_other', 'equity_unaffected'])]` dengan `date_scope="from_fiscalyear"`.
  * Baris **`Previous Years Earnings` (PYE):** Mengakumulasikan laba tahun-tahun sebelumnya secara dinamis dengan filter yang sama menggunakan `date_scope="to_beginning_of_fiscalyear"`.
* **File:** `enterprise/account_reports/models/account_report.py`
  ```python
  UNDISTR_LINE_NAME = _lt("Result Brought Forward")
  ```
  *Penjelasan:* Pada General Ledger dan Trial Balance, akun penampung virtual ini secara dinamis dinamai baris **`Result Brought Forward`**.

### C. Bukti Jurnal Alokasi Laba Bersih
* **File:** `enterprise/account_reports/tests/test_trial_balance_report.py` (Unit test resmi Odoo)
  ```python
  # Allocate the prior year's income into retained earnings, zeroing out
  # the unallocated earnings balance for the fiscal year.
  equity_unaffected_acc = self.env['account.account'].search([
      ('account_type', '=', 'equity_unaffected'),
      ('company_ids', 'in', self.company_data['company'].ids),
  ], limit=1)

  move_allocation = self.env['account.move'].create([{
      'move_type': 'entry',
      'date': fields.Date.from_string('2009-12-31'),
      'journal_id': self.company_data['default_journal_misc'].id,
      'line_ids': [
          Command.create({'debit': 0.0, 'credit': 1000.0, 'name': 'allocate income', 'account_id': retained_earnings_acc.id}),
          Command.create({'debit': 1000.0, 'credit': 0.0, 'name': 'allocate income', 'account_id': equity_unaffected_acc.id}),
      ],
  }])
  ```
  *Penjelasan:* Odoo membuktikan bahwa alokasi laba dilakukan dengan mendebet akun bertipe `equity_unaffected` dan mengkredit Laba Ditahan per tanggal **31 Desember**.

### D. Bukti Navigasi Menu & Perilaku Hard Lock di Odoo 19
* **File:** `enterprise/account_accountant/wizard/account_change_lock_date.xml`
  * Action Lock Dates didaftarkan langsung di bawah menu Closing:
    ```xml
    <menuitem id="menu_action_change_lock_date" 
              name="Lock Dates…" 
              action="action_view_account_change_lock_date" 
              parent="account.account_closing_menu" 
              sequence="70" 
              groups="account.group_account_manager"/>
    ```
* **File:** `odoo/addons/account/models/company.py`
  * Validasi ketat *Hard Lock* yang tidak dapat dibatalkan atau dimundurkan:
    ```python
    if 'hard_lock_date' in new_locks:
        for company in self:
            if not company.hard_lock_date:
                continue
            if not hard_lock_date:
                raise UserError(_("The Hard Lock Date cannot be removed."))
            if hard_lock_date < company.hard_lock_date:
                raise UserError(_("A new Hard Lock Date must be posterior (or equal) to the previous one."))
    ```
