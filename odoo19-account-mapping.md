# Mapping Tipe Akun (Chart of Accounts) Odoo 19 — Inggris ⇄ Indonesia

Referensi umum tipe akun (`account_type`) dan kelompok internal (`internal_group`) pada Chart of Accounts Odoo 19, lengkap dengan padanan Bahasa Indonesia, id teknis, external id, dan default value-nya.

Sumber:
- Definisi field & logika default: `odoo/addons/account/models/account_account.py`
- id, External ID & label Indonesia: diverifikasi langsung dari tabel `ir_model_fields_selection` (kolom `name->>'id_ID'`) pada database `fresh` setelah bahasa Indonesia (`id_ID`) diinstall — hasilnya identik dengan file terjemahan statis `odoo/addons/account/i18n/id.po`. Data ini bawaan setiap instalasi Odoo 19 — bukan spesifik satu database tertentu.

**Daftar isi:** [Model/Tabel Penyimpanan](#model--tabel-penyimpanan) · [Default Value](#default-value) · [Tabel `account_type`](#field-account_type-tipe-akun--19-opsi) · [Tabel `internal_group`](#field-internal_group-kelompok-internal--6-opsi) · [Akun Default Preload (l10n_id)](#akun-akun-default-preload-template-coa-indonesia--modul-l10n_id) · [Catatan](#catatan)

## Model / Tabel Penyimpanan

| Field | Model Odoo | Tempat nilai per-akun disimpan | Tempat master data opsi (label) disimpan |
|---|---|---|---|
| `account_type` | `account.account` | Tabel `account_account`, kolom `account_type` (stored, `varchar`) | Tabel `ir_model_fields_selection`, filter `field_id` → `ir_model_fields` (`model='account.account'`, `name='account_type'`) |
| `internal_group` | `account.account` | **Tidak ada kolom DB** — computed dari `account_type` (`compute='_compute_internal_group'`, tanpa `store=True`) | Tabel `ir_model_fields_selection` (tetap direfleksikan walau field-nya sendiri tidak stored) |

Ada **dua lapis** penyimpanan:

1. **Nilai per-record** (mis. akun "1-1000 Kas" bertipe `asset_cash`) → string langsung di kolom `account_account.account_type`.
2. **Master data pilihan/opsi** (19 pilihan `account_type` + label) → direfleksikan otomatis ke model **`ir.model.fields.selection`** (tabel `ir_model_fields_selection`) setiap registry Odoo di-load (`_reflect_selections` di [ir_model.py](odoo/odoo/addons/base/models/ir_model.py), dipanggil dari [registry.py:783](odoo/odoo/orm/registry.py#L783)). Setiap baris punya `id` integer asli **dan** External ID (XML ID) via `ir.model.data`, format:
   `<module>.selection__<model_dengan_underscore>__<field>__<value>`

> Sumber kebenaran tetap kode Python `selection=[...]`; `ir_model_fields_selection` adalah *reflection*/cache-nya (dipakai untuk translation string, fitur Studio, dan referensi via External ID). `id` numerik bersifat instance-specific (auto-increment, bisa beda per database); External ID (`module.xml_name`) yang stabil dan portable lintas instalasi.

## Default Value

Field `account_type` **wajib diisi** (`required=True`) dan dihitung otomatis (`compute='_compute_account_type'`) saat sebuah akun dibuat tanpa tipe eksplisit:

1. Odoo mencoba mencocokkan **kode akun** dengan range kode akun induk (parent) yang sudah ada, lalu mewarisi `account_type` dari situ (`_get_closest_parent_account`, `account_account.py:614-637`).
2. Jika tidak ada akun induk yang cocok, dipakai default hardcode: **`asset_current`** → *Current Assets* / **Aktiva Lancar** (`account_account.py:607`).

## Field `account_type` (Tipe Akun) — 19 opsi

| id (DB) | External ID | Kode Teknis (`value`) | Label Inggris | Label Indonesia | Internal Group | sequence |
|---|---|---|---|---|---|---|
| 1249 | `account.selection__account_account__account_type__asset_receivable` | `asset_receivable` | Receivable | Piutang | asset | 0 |
| 1250 | `account.selection__account_account__account_type__asset_cash` | `asset_cash` | Bank and Cash | Bank dan Tunai | asset | 1 |
| 1251 | `account.selection__account_account__account_type__asset_current` | `asset_current` | Current Assets | Aktiva Lancar | asset | 2 |
| 1252 | `account.selection__account_account__account_type__asset_non_current` | `asset_non_current` | Non-current Assets | Aktiva Tidak Lancar | asset | 3 |
| 1253 | `account.selection__account_account__account_type__asset_prepayments` | `asset_prepayments` | Prepayments | Prabayar | asset | 4 |
| 1254 | `account.selection__account_account__account_type__asset_fixed` | `asset_fixed` | Fixed Assets | Aktiva Tetap | asset | 5 |
| 1255 | `account.selection__account_account__account_type__liability_payable` | `liability_payable` | Payable | Utang | liability | 6 |
| 1256 | `account.selection__account_account__account_type__liability_credit_card` | `liability_credit_card` | Credit Card | Kartu Kredit | liability | 7 |
| 1257 | `account.selection__account_account__account_type__liability_current` | `liability_current` | Current Liabilities | Pasiva Terkini | liability | 8 |
| 1258 | `account.selection__account_account__account_type__liability_non_current` | `liability_non_current` | Non-current Liabilities | Hutang Tidak Lancar | liability | 9 |
| 1259 | `account.selection__account_account__account_type__equity` | `equity` | Equity | Ekuitas | equity | 10 |
| 1260 | `account.selection__account_account__account_type__equity_unaffected` | `equity_unaffected` | Current Year Earnings | Penghasilan Tahun Terkini | equity | 11 |
| 1261 | `account.selection__account_account__account_type__income` | `income` | Income | Penghasilan | income | 12 |
| 1262 | `account.selection__account_account__account_type__income_other` | `income_other` | Other Income | Penghasilan Lainnya | income | 13 |
| 1263 | `account.selection__account_account__account_type__expense` | `expense` | Expenses | Pengeluaran | expense | 14 |
| 1264 | `account.selection__account_account__account_type__expense_other` | `expense_other` | Other Expenses | Pengeluaran Lainnya | expense | 15 |
| 1265 | `account.selection__account_account__account_type__expense_depreciation` | `expense_depreciation` | Depreciation | Penyusutan | expense | 16 |
| 1266 | `account.selection__account_account__account_type__expense_direct_cost` | `expense_direct_cost` | Cost of Revenue | Biaya Pendapatan | expense | 17 |
| 1267 | `account.selection__account_account__account_type__off_balance` | `off_balance` | Off-Balance Sheet | Off-Balance Sheet | off | 18 |

*(`asset_current`, id 1251, adalah default value bila kode akun tidak cocok dengan akun induk manapun — lihat bagian Default Value di atas.)*

## Field `internal_group` (Kelompok Internal) — 6 opsi

| id (DB) | External ID | Kode Teknis (`value`) | Label Inggris | Label Indonesia | sequence |
|---|---|---|---|---|---|
| 1268 | `account.selection__account_account__internal_group__equity` | `equity` | Equity | Ekuitas | 0 |
| 1269 | `account.selection__account_account__internal_group__asset` | `asset` | Asset | Aktiva | 1 |
| 1270 | `account.selection__account_account__internal_group__liability` | `liability` | Liability | Hutang | 2 |
| 1271 | `account.selection__account_account__internal_group__income` | `income` | Income | Penghasilan | 3 |
| 1272 | `account.selection__account_account__internal_group__expense` | `expense` | Expense | Pengeluaran | 4 |
| 1273 | `account.selection__account_account__internal_group__off` | `off` | Off Balance | Off Balance | 5 |

## Akun-akun Default Preload (Template CoA Indonesia — modul `l10n_id`)

Saat modul **"Indonesian - Accounting"** (`l10n_id`) diinstal / fiscal localization perusahaan diset ke Indonesia, Odoo memuat 114 akun default dari template CoA ini. Sumber: [`odoo/addons/l10n_id/data/template/account.account-id.csv`](odoo/addons/l10n_id/data/template/account.account-id.csv), didaftarkan sebagai chart template kode `'id'` via decorator `@template('id')` di [`models/template_id.py`](odoo/addons/l10n_id/models/template_id.py).

- External ID tiap akun berformat `l10n_id_<kode>` (mis. `l10n_id_11210010`), module `l10n_id`.
- Kolom "Nama (Indonesia)" berasal dari kolom `name@id` di CSV tersebut; tanda **—** berarti tidak ada override Indonesia (nama Inggris tetap dipakai di UI meski locale `id_ID` aktif).
- Beberapa akun dengan kode/nama yang sama (mis. "Office Building", "Vehicle") muncul dua kali dengan `account_type` berbeda: sekali sebagai Fixed Assets (`asset_fixed`), sekali lagi sebagai akun akumulasi penyusutan (`expense_depreciation`).

### Akun properti default (dipakai otomatis oleh sistem)

Dikonfigurasi di [`template_id.py`](odoo/addons/l10n_id/models/template_id.py):

| Fungsi | Kode Akun | Nama Inggris | Nama Indonesia |
|---|---|---|---|
| Default Account Receivable (`property_account_receivable_id`) | `11210010` | Account Receivable | Piutang Usaha |
| Default Account Payable (`property_account_payable_id`) | `21100010` | Account Payable | Hutang Usaha |
| Stock Valuation Account (`property_stock_valuation_account_id`) | `11300180` | Inventory | Persediaan Lainnya |
| POS Receivable (`account_default_pos_receivable_account_id`) | `11210011` | Account Receivable (PoS) | Piutang Usaha (PoS) |
| Cash Difference Income (`default_cash_difference_income_account_id`) | `99900002` | Cash Difference Gain | — |
| Cash Difference Expense (`default_cash_difference_expense_account_id`) | `99900001` | Cash Difference Loss | — |
| Currency Exchange Income (`income_currency_exchange_account_id`) | `81100030` | Foreign Exchange Gain | Keuntungan Selisih Kurs |

### Daftar lengkap 114 akun preload

| Kode | Nama (Inggris) | Nama (Indonesia) | Tipe Akun (`account_type`) | Label Tipe (ID) | Reconcile |
|---|---|---|---|---|---|
| `11110001` | Cash | — | `asset_cash` | Bank dan Tunai | Tidak |
| `11110010` | Petty Cash | Kas Kecil | `asset_cash` | Bank dan Tunai | Tidak |
| `11120001` | Bank | — | `asset_cash` | Bank dan Tunai | Tidak |
| `11210010` | Account Receivable | Piutang Usaha | `asset_receivable` | Piutang | Ya |
| `11210011` | Account Receivable (PoS) | Piutang Usaha (PoS) | `asset_receivable` | Piutang | Ya |
| `11210012` | VAT Receivable | — | `asset_receivable` | Piutang | Ya |
| `11210013` | STLG Receivable | — | `asset_receivable` | Piutang | Ya |
| `11210014` | PPh 28A Prepaid | — | `asset_receivable` | Piutang | Ya |
| `11210030` | VAT Purchase | — | `asset_current` | Aktiva Lancar | Tidak |
| `11210040` | Prepaid Expense | — | `asset_current` | Aktiva Lancar | Tidak |
| `11300180` | Inventory | Persediaan Lainnya | `asset_current` | Aktiva Lancar | Tidak |
| `11410010` | Building Rent | Sewa Bangunan | `asset_prepayments` | Prabayar | Tidak |
| `11410020` | Prepaid Insurance | Asuransi Dibayar Dimuka | `asset_prepayments` | Prabayar | Tidak |
| `11410030` | Prepaid Advertisement-Free | Beban Iklan Dibayar Dimuka | `asset_prepayments` | Prabayar | Tidak |
| `11510010` | Prepaid Tax PPh 21 | — | `asset_prepayments` | Prabayar | Tidak |
| `11510020` | Prepaid Tax Pph 22 | Pajak Dibayar Dimuka PPH 22 | `asset_prepayments` | Prabayar | Tidak |
| `11510030` | Prepaid Tax Pph 23 | Pajak Dibayar Dimuka PPH 23 | `asset_prepayments` | Prabayar | Tidak |
| `11510040` | Prepaid Tax Pph 25 | Pajak Dibayar Dimuka PPH 25 | `asset_prepayments` | Prabayar | Tidak |
| `11800000` | Down Payment | Uang Muka Pembelian | `asset_prepayments` | Prabayar | Tidak |
| `12210010` | Office Building | Bangunan Kantor | `asset_fixed` | Aktiva Tetap | Tidak |
| `12210020` | Vehicle | Kendaraan | `asset_fixed` | Aktiva Tetap | Tidak |
| `12210030` | Office Supplies | Peralatan Kantor | `asset_fixed` | Aktiva Tetap | Tidak |
| `12281010` | Accumulation Building Depreciation | Akumulasi Penyusutan Bangunan Kantor | `asset_fixed` | Aktiva Tetap | Tidak |
| `12281020` | Accumulation Vehicle Depreciation | Akumulasi Penyusutan Kendaraan | `asset_fixed` | Aktiva Tetap | Tidak |
| `12281030` | Accumulation Office Supplies Depreciation | Akumulasi Penyusutan Peralatan Kantor | `asset_fixed` | Aktiva Tetap | Tidak |
| `21100010` | Account Payable | Hutang Usaha | `liability_payable` | Utang | Ya |
| `21100011` | VAT Payable | — | `liability_payable` | Utang | Ya |
| `21100012` | STLG Payable | — | `liability_payable` | Utang | Ya |
| `21100013` | Employee Liabilities | Piutang Karyawan | `liability_current` | Pasiva Terkini | Ya |
| `21100014` | Tax Payable PPh 29 | — | `liability_payable` | Utang | Ya |
| `21100020` | Shareholder Deposit | Hutang Pemegang Saham | `liability_current` | Pasiva Terkini | Tidak |
| `21100030` | Third-Party Deposit | Hutang Pihak Ketiga | `liability_current` | Pasiva Terkini | Tidak |
| `21100040` | Salary Deposit | Hutang Gaji | `liability_current` | Pasiva Terkini | Tidak |
| `21210010` | Tax Payable PPh 21 | Hutang Pajak PPh 21 | `liability_current` | Pasiva Terkini | Ya |
| `21210020` | Tax Payable PPh 22 | Hutang Pajak PPh 22 | `liability_current` | Pasiva Terkini | Ya |
| `21210030` | Tax Payable PPh 23 | Hutang Pajak PPh 23 | `liability_current` | Pasiva Terkini | Ya |
| `21210040` | Tax Payable PPh 25 | Hutang Pajak PPh 25 | `liability_current` | Pasiva Terkini | Ya |
| `21210050` | Tax Payable 4(2) | Hutang Pajak Pasal 4 (2) | `liability_current` | Pasiva Terkini | Ya |
| `21210060` | Tax Payable PPh 26 | Hutang Pajak PPh 26 | `liability_current` | Pasiva Terkini | Ya |
| `21221010` | VAT Sales | PPN Pembelian | `liability_current` | Pasiva Terkini | Tidak |
| `22110010` | Bank Loan | Hutang Bank | `liability_current` | Pasiva Terkini | Tidak |
| `22110020` | Leasing Deposit | Hutang Leasing | `liability_current` | Pasiva Terkini | Tidak |
| `25110010` | Accrued Payable Electricity | BYMHD Listrik | `liability_current` | Pasiva Terkini | Tidak |
| `25110020` | Accrued Payable Jamsostek | BYMHD Jamsostek | `liability_current` | Pasiva Terkini | Tidak |
| `25110030` | Accrued Payable Water | BYMHD Air | `liability_current` | Pasiva Terkini | Tidak |
| `25110040` | Accrued Payable Telp & Internet | BYMHD Telepon | `liability_current` | Pasiva Terkini | Tidak |
| `25110050` | Accrued Payable Security Management | BYMHD Jasa Pengelola Keamanan | `liability_current` | Pasiva Terkini | Tidak |
| `25110060` | Accrued Payable Bank | BYMHD Bank | `liability_current` | Pasiva Terkini | Tidak |
| `25110070` | Accrued Payable PBB | BYMHD PBB | `liability_current` | Pasiva Terkini | Tidak |
| `25110080` | Accrued Payable Business License | BYMHD Izin Usaha | `liability_current` | Pasiva Terkini | Tidak |
| `25110090` | Accrued Payable Insurance | BYMHD Asuransi | `liability_current` | Pasiva Terkini | Tidak |
| `25110100` | Accrued Payable Education | BYMHD Pendidikan dan Latihan | `liability_current` | Pasiva Terkini | Tidak |
| `25110110` | Accrued Payable Health Insurance/BPJS | BYMHD Jaminan Kesehatan/BPJS | `liability_current` | Pasiva Terkini | Tidak |
| `28110010` | Advance Sales | Uang Muka Penjualan | `liability_current` | Pasiva Terkini | Tidak |
| `28110020` | Customer Deposit | Deposit Customer | `liability_current` | Pasiva Terkini | Tidak |
| `28110030` | Deferred Revenue | — | `liability_current` | Pasiva Terkini | Tidak |
| `29000000` | Interim Stock | Stok Interim | `liability_current` | Pasiva Terkini | Tidak |
| `31100010` | Authorized Capital | Modal Dasar | `equity` | Ekuitas | Tidak |
| `31100020` | Paid Capital | Modal Yang Disetor | `equity` | Ekuitas | Tidak |
| `31100030` | Unpaid Capital | Modal Yang Belum Disetor | `equity` | Ekuitas | Tidak |
| `31100040` | Prive (Personal Retrieval) | Prive (Pengambilan Pribadi) | `equity` | Ekuitas | Tidak |
| `31210010` | Capital Reserves | Cadangan Modal | `equity` | Ekuitas | Tidak |
| `31510010` | Past Profit & Loss | Laba Rugi Tahun Lalu | `equity` | Ekuitas | Tidak |
| `31510020` | Ongoing Profit & Loss | Laba Rugi Tahun Berjalan | `equity` | Ekuitas | Tidak |
| `39000000` | Historical Balance | Historical Balance | `equity` | Ekuitas | Ya |
| `41000010` | Sales | Penjualan | `income` | Penghasilan | Tidak |
| `42000060` | Sales Refund | Retur Penjualan | `income` | Penghasilan | Tidak |
| `42000070` | Sales Discount | Discount Penjualan | `income` | Penghasilan | Tidak |
| `42500010` | Change in Inventory | Perubahan Persediaan | `expense` | Pengeluaran | Tidak |
| `51000010` | Cost of Goods Sold | Harga Pokok Penjualan | `expense_direct_cost` | Biaya Pendapatan | Tidak |
| `51000020` | Purchases - Raw Materials | Pembelian Bahan Baku | `expense` | Pengeluaran | Tidak |
| `61100010` | Employee Salary | Gaji Karyawan | `expense` | Pengeluaran | Tidak |
| `61100020` | Employee Bonus / Benefits | Tunjangan/ Bonus Karyawan | `expense` | Pengeluaran | Tidak |
| `61100030` | Employee Overtime Pay | Lembur Karyawan | `expense` | Pengeluaran | Tidak |
| `61100100` | Pph 21 Benefit | Tunjangan PPH Pasal 21 | `expense` | Pengeluaran | Tidak |
| `61100110` | PPh 22 Final | — | `expense` | Pengeluaran | Tidak |
| `61100120` | PPh 4(2) Final | — | `expense` | Pengeluaran | Tidak |
| `63110060` | Phone | Telepon | `expense` | Pengeluaran | Tidak |
| `63110080` | Electricity | Listrik | `expense` | Pengeluaran | Tidak |
| `63110100` | Research & Development | Research & Development | `expense` | Pengeluaran | Tidak |
| `63110120` | Office Equipment | Perlengkapan Kantor | `expense` | Pengeluaran | Tidak |
| `64110020` | Post Necessities | Keperluan Pos | `expense` | Pengeluaran | Tidak |
| `63110140` | Other Necessities | Keperluan Lain-lain | `expense` | Pengeluaran | Tidak |
| `65110010` | Licensing Fees | Biaya Perizinan | `expense` | Pengeluaran | Tidak |
| `65110020` | Bank Administration Fees | Biaya Administrasi Bank | `expense` | Pengeluaran | Tidak |
| `65110030` | Consultant Fees | Biaya Konsultan | `expense` | Pengeluaran | Tidak |
| `65110040` | Rental Costs | Biaya Sewa | `expense` | Pengeluaran | Tidak |
| `65110050` | Insurance Costs | — | `expense` | Pengeluaran | Tidak |
| `65110060` | Building Maintenance Costs | Biaya Pemeliharaan & Perawatan Gedung | `expense` | Pengeluaran | Tidak |
| `65110070` | Income Tax Expenses (CIT) | Pajak | `expense` | Pengeluaran | Tidak |
| `65110080` | Asset Maintenance Costs | Biaya Pemeliharaan & Perawatan Aset | `expense` | Pengeluaran | Tidak |
| `65110090` | Shipping Costs | Biaya Pengiriman Dokumen/Barang | `expense` | Pengeluaran | Tidak |
| `66110010` | Vehicle Fuel | BBM kendaraan | `expense` | Pengeluaran | Tidak |
| `66110020` | Vehicle Service | Service kendaraan | `expense` | Pengeluaran | Tidak |
| `66110030` | Vehicle Parking & Toll Fee | Parkir & tol kendaraan | `expense` | Pengeluaran | Tidak |
| `66110040` | Vehicle Taxes | Pajak Kendaraan | `expense` | Pengeluaran | Tidak |
| `66110050` | Vehicle Insurance | Asuransi Kendaraan | `expense` | Pengeluaran | Tidak |
| `67100010` | Office Building | Bangunan Kantor | `expense_depreciation` | Penyusutan | Tidak |
| `67100020` | Vehicle | Kendaraan | `expense_depreciation` | Penyusutan | Tidak |
| `67100030` | Office Supplies | Peralatan Kantor | `expense_depreciation` | Penyusutan | Tidak |
| `69000000` | Other Expenses | Biaya Lain-lain | `expense` | Pengeluaran | Tidak |
| `81100010` | Interest Income | Pendapatan Bunga | `income_other` | Penghasilan Lainnya | Tidak |
| `81100020` | Deposit Income | Pendapatan Deposit | `income_other` | Penghasilan Lainnya | Tidak |
| `81100030` | Foreign Exchange Gain | Keuntungan Selisih Kurs | `income_other` | Penghasilan Lainnya | Tidak |
| `81100040` | Other Income | Pendapatan lainnya | `income_other` | Penghasilan Lainnya | Tidak |
| `81100050` | Gain on Sale of Fixed Assets | Keuntungan Atas Penjualan Aktiva Tetap | `income_other` | Penghasilan Lainnya | Tidak |
| `91100010` | Interest Expense | Beban Bunga | `expense` | Pengeluaran | Tidak |
| `91100020` | Foreign Exchange Loss | Kerugian Selisih Kurs | `expense` | Pengeluaran | Tidak |
| `91100030` | Loss on Sale of Fixed Assets | Kerugian Atas Penjualan Aktiva Tetap | `expense` | Pengeluaran | Tidak |
| `99900001` | Cash Difference Loss | — | `expense` | Pengeluaran | Tidak |
| `99900002` | Cash Difference Gain | — | `income` | Penghasilan | Tidak |
| `99900003` | Cash Discount Loss | — | `expense` | Pengeluaran | Tidak |
| `99900004` | Cash Discount Gain | — | `income_other` | Penghasilan Lainnya | Tidak |
| `999999` | Undistributed Profits/Losses | — | `equity_unaffected` | Penghasilan Tahun Terkini | Tidak |

## Catatan

- Kode teknis `account_type` mengikuti pola `<internal_group>_<subtipe>`, contoh `asset_cash` = kelompok `asset` + subtipe `cash`.
- External ID (`account.selection__...`) adalah kunci yang stabil untuk merujuk ke opsi ini lintas instalasi/environment (mis. via `ref()` di data XML modul lain yang melakukan `selection_add`). `id` numerik di kolom pertama tabel di atas bersifat instance-specific (auto-increment PostgreSQL, akan berbeda nilainya di tiap database) — jangan dijadikan referensi tetap.
- Beberapa istilah (`Off-Balance Sheet`, `Off Balance`) belum diterjemahkan di `id.po` bawaan Odoo — istilah Inggris tetap dipakai sebagai istilah Indonesia di UI.
- `asset_receivable` dan `liability_payable` adalah tipe khusus yang dipakai otomatis untuk akun rekonsiliasi piutang/utang pelanggan & vendor (lihat constraint di `account_account.py:27-30`).
- Definisi field Python: `odoo/addons/account/models/account_account.py:44-88`.
- Logika default value: `odoo/addons/account/models/account_account.py:605-637`.
- Definisi model `ir.model.fields.selection` & mekanisme reflect: `odoo/addons/base/models/ir_model.py` (class `IrModelFieldsSelection`, method `_reflect_selections`), dipanggil dari `odoo/orm/registry.py` saat setup registry.
