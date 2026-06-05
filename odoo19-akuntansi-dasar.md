# Panduan Dasar Akuntansi & Keuangan untuk Non-Akuntan
## Modul Pendukung Training Odoo 19.0 LTS Enterprise

---

### Tentang Panduan Ini

Dokumen ini dirancang khusus untuk membantu tim non-akuntansi (Sales, Purchasing, Inventory, IT, dll.) memahami istilah-istilah keuangan dasar sebelum praktik di Odoo 19.0 Enterprise.

Di Odoo 19, semua pencatatan akuntansi berjalan otomatis di balik layar. Namun, memahami konsep dasarnya akan membuat Anda lebih percaya diri saat mengoperasikan sistem dan memahami dampak dari setiap data yang Anda input.

Kalau dipahami secara sederhana, akuntansi itu sebenarnya hanya soal: **mencatat transaksi dengan rapi, lalu melihat dampaknya ke uang, aset, utang, dan laba perusahaan.**

---

## 1. COA (Chart of Accounts / Daftar Akun)

### Pengertian Sederhana

COA adalah **daftar semua akun keuangan** yang dipakai perusahaan untuk mencatat transaksi.

Bayangkan COA sebagai **lemari arsip besar** di kantor Anda. Agar dokumen tidak berantakan, lemari ini dibagi menjadi beberapa laci utama, dan setiap laci memiliki folder dengan nomor kode khusus. Semua transaksi harus masuk ke laci yang tepat.

### 5 Laci Utama dalam Akuntansi

| No | Laci (Kategori) | Isi / Penjelasan | Contoh Akun |
|:---|:---|:---|:---|
| 1 | **Aset (Harta)** | Kekayaan yang dimiliki perusahaan | Kas, Bank, Stok Barang, Gedung |
| 2 | **Liabilitas (Hutang)** | Kewajiban/utang kepada pihak lain | Utang ke Supplier, Pinjaman Bank |
| 3 | **Ekuitas (Modal)** | Hak pemilik atas kekayaan perusahaan | Modal Awal, Laba Ditahan |
| 4 | **Pendapatan (Revenue)** | Uang masuk dari penjualan produk/jasa | Penjualan Barang, Pendapatan Jasa |
| 5 | **Beban (Expense)** | Uang keluar untuk operasional | Gaji, Listrik, Sewa Kantor |

### Contoh Penggunaan

- Perusahaan menerima pembayaran dari pelanggan lewat transfer bank → masuk ke akun **Bank**
- Perusahaan membeli laptop untuk kantor → masuk ke akun **Aset Tetap / Peralatan Kantor**

### Kenapa COA Penting?

Tanpa COA, transaksi akan berantakan dan laporan keuangan sulit dibuat. COA adalah fondasi dari seluruh sistem pencatatan keuangan.

> **Odoo 19 Context:**
> Saat pertama kali menginstal aplikasi *Accounting* di Odoo 19 dan memilih lokalisasi negara (misalnya: *Indonesia - Chart of Accounts*), Odoo akan otomatis membuatkan susunan "lemari arsip" ini sesuai dengan standar akuntansi yang berlaku di Indonesia (PSAK). Anda tidak perlu menyusunnya dari nol.

---

## 2. Aset (Assets)

### Pengertian Sederhana

**Aset** adalah seluruh barang, properti, uang, atau hak milik yang dikendalikan oleh perusahaan yang memiliki nilai ekonomi. Aset bisa dipakai untuk operasional, dijual, atau menghasilkan uang.

### Jenis-Jenis Aset

#### a. Aset Lancar (Current Assets)

Aset yang bentuknya uang tunai atau sangat mudah diubah menjadi uang tunai dalam jangka waktu kurang dari 1 tahun.

**Contoh:**
- Uang kas kecil di kantor
- Saldo di rekening bank
- Stok barang dagangan (Inventory) yang siap dijual
- Piutang usaha (tagihan ke pelanggan yang belum dibayar)

#### b. Aset Tetap (Fixed Assets)

Barang berharga milik perusahaan yang dibeli untuk digunakan dalam jangka panjang (lebih dari 1 tahun), bukan untuk dijual langsung.

**Contoh:**
- Komputer kerja karyawan
- Mobil pick-up operasional
- Mesin pabrik
- Bangunan kantor

### Cara Membedakannya

Kalau perusahaan membeli printer seharga Rp 3.000.000 untuk dipakai kerja, itu dicatat sebagai **aset**, bukan langsung habis seperti beli pulsa atau air minum. Karena printer akan memberikan manfaat lebih dari satu periode.

> **Odoo 19 Context:**
> Odoo 19 Enterprise memiliki modul **Fixed Assets**. Ketika Anda membeli laptop baru seharga Rp 12 juta yang akan dipakai selama 3 tahun, Odoo akan otomatis memotong nilai aset tersebut sebesar Rp 333.333 setiap bulannya sebagai biaya penyusutan (depresiasi) tanpa perlu dihitung manual di Excel.

---

## 3. Debet dan Kredit (Prinsip Keseimbangan)

### Pengertian Sederhana

Banyak orang salah mengira bahwa *Debet = Uang Masuk* dan *Kredit = Uang Keluar*. **Ini kurang tepat dalam akuntansi.**

Debet dan kredit adalah **dua sisi pencatatan akuntansi**. Cara termudah memahaminya adalah melihatnya seperti **timbangan dua sisi**:

- **Debet** adalah sisi **KIRI**
- **Kredit** adalah sisi **KANAN**

Setiap kali ada transaksi, timbangan ini harus tetap **seimbang (balance)**. Jika ada sesuatu yang bertambah di satu sisi, pasti ada hal lain yang berubah di sisi pasangannya.

### Aturan Timbangan Akuntansi

| Jenis Akun | Jika BERTAMBAH, catat di: | Jika BERKURANG, catat di: | Masuk Laporan |
|:---|:---|:---|:---|
| **Aset (Harta)** | Kiri (Debet) | Kanan (Kredit) | Neraca |
| **Beban (Biaya)** | Kiri (Debet) | Kanan (Kredit) | Laba Rugi |
| **Hutang** | Kanan (Kredit) | Kiri (Debet) | Neraca |
| **Modal** | Kanan (Kredit) | Kiri (Debet) | Neraca |
| **Pendapatan** | Kanan (Kredit) | Kiri (Debet) | Laba Rugi |

### Contoh 1: Menerima Pembayaran

Perusahaan menerima uang tunai Rp 1.000.000 dari pelanggan.

| Akun | Debet | Kredit |
|:---|:---|:---|
| Kas | Rp 1.000.000 | |
| Penjualan | | Rp 1.000.000 |

Artinya: Uang kas **bertambah** (debet), pendapatan penjualan juga **bertambah** (kredit).

### Contoh 2: Membeli Perlengkapan

Perusahaan membeli perlengkapan kantor tunai Rp 200.000.

| Akun | Debet | Kredit |
|:---|:---|:---|
| Beban Perlengkapan | Rp 200.000 | |
| Kas | | Rp 200.000 |

Artinya: Beban **bertambah** (debet), uang kas **berkurang** (kredit).

---

## 4. Journal Entries (Jurnal Transaksi)

### Pengertian Sederhana

**Journal Entries** adalah **buku harian kronologis** perusahaan. Setiap kali terjadi peristiwa bisnis, kejadian tersebut harus dicatat. Jurnal adalah catatan transaksi pertama kali sebelum dipindahkan ke laporan keuangan.

Format umumnya:
- Tanggal
- Akun yang didebet
- Akun yang dikredit
- Nominal
- Keterangan transaksi

Satu baris Journal Entry minimal harus melibatkan dua akun: satu di posisi Debet dan satu di posisi Kredit, dengan nilai yang **harus sama besar**.

### Contoh Kasus

Perusahaan membeli sebuah **Laptop Kerja** seharga **Rp 10.000.000** secara tunai menggunakan uang di Bank.

*Analisis:*
1. Laptop (Aset Tetap) perusahaan **bertambah** → catat di **Debet**
2. Uang di Bank (Aset Lancar) perusahaan **berkurang** → catat di **Kredit**

**Jurnal:**

| Akun | Debet | Kredit |
|:---|:---|:---|
| Peralatan Kantor (Laptop) | Rp 10.000.000 | |
| Bank | | Rp 10.000.000 |

### Contoh Lain

Tanggal 5 Juni, perusahaan membayar biaya listrik Rp 300.000.

| Akun | Debet | Kredit |
|:---|:---|:---|
| Beban Listrik | Rp 300.000 | |
| Kas/Bank | | Rp 300.000 |

### Kenapa Jurnal Penting?

Semua laporan keuangan berasal dari jurnal yang benar. Kalau jurnal salah, hasil laporan juga salah.

> **Odoo 19 Context:**
> Di Odoo 19, staf operasional *tidak perlu tahu* cara menjurnal secara manual. Ketika tim Finance memvalidasi *Vendor Bill* atau *Customer Invoice*, Odoo secara otomatis membuatkan Journal Entries di latar belakang sistem. Yang penting: data yang Anda input di setiap tahap (PO, penerimaan barang, SO, pengiriman) harus akurat karena menjadi dasar pembuatan jurnal tersebut.

---

## 5. Neraca (Balance Sheet)

### Pengertian Sederhana

**Neraca** adalah **foto instan (snapshot)** kondisi keuangan perusahaan pada satu tanggal tertentu (misalnya: per tanggal 31 Desember).

Neraca menjawab pertanyaan:
- Perusahaan punya apa? (Aset)
- Perusahaan punya utang berapa? (Liabilitas)
- Modal pemilik berapa? (Ekuitas)

### Rumus Utama Neraca

```
ASET = LIABILITAS (Hutang) + EKUITAS (Modal)
```

Artinya: semua yang dimiliki perusahaan sumbernya pasti dari pinjaman/utang, atau modal pemilik. Kedua sisi harus selalu **seimbang**.

### Contoh Analogi

Anda membeli rumah seharga **Rp 1 Miliar**:
- Pinjam ke Bank: Rp 600 Juta
- Uang tabungan sendiri: Rp 400 Juta

Neraca-nya:
- **Sisi Kiri (Aset):** Rumah senilai Rp 1 Miliar
- **Sisi Kanan (Sumber Dana):** Hutang Bank Rp 600 Juta + Modal Sendiri Rp 400 Juta = Rp 1 Miliar

### Contoh dalam Bisnis

Perusahaan punya:
- Kas: Rp 10.000.000
- Piutang: Rp 5.000.000
- Peralatan: Rp 15.000.000
- **Total Aset: Rp 30.000.000**

Sumber dananya:
- Utang usaha: Rp 8.000.000
- Modal pemilik: Rp 22.000.000
- **Total Utang + Modal: Rp 30.000.000**

Seimbang.

---

## 6. Laba Rugi (Profit & Loss / Income Statement)

### Pengertian Sederhana

Jika Neraca adalah "foto diam" pada satu titik waktu, maka **Laba Rugi** adalah **video rekaman perjalanan**. Laporan ini merekam performa bisnis Anda selama rentang periode tertentu (sebulan, setahun).

Tujuannya: Menunjukkan apakah bisnis Anda menghasilkan **untung (Laba)** atau **rugi**.

### Rumus Laba Rugi

```
PENDAPATAN - BEBAN = LABA (atau RUGI)
```

### Contoh

Selama bulan Januari:
- Pendapatan penjualan: Rp 50.000.000
- Total beban (sewa, listrik, gaji): Rp 35.000.000

Hasilnya:
- Rp 50.000.000 - Rp 35.000.000 = **Laba Rp 15.000.000** (Untung!)

Kalau pendapatan hanya Rp 30.000.000 dan beban Rp 35.000.000, maka hasilnya **Rugi Rp 5.000.000**.

### Bedanya dengan Neraca

| | Neraca | Laba Rugi |
|:---|:---|:---|
| Fungsi | Melihat posisi keuangan | Melihat kinerja/performa |
| Waktu | Pada tanggal tertentu | Selama periode tertentu |
| Pertanyaan | "Kondisi kita sekarang bagaimana?" | "Bulan ini kita untung atau rugi?" |

> **Odoo 19 Context:**
> Laporan Laba Rugi di Odoo 19 bersifat *dynamic & real-time*. Anda bisa filter performa berdasarkan divisi, proyek, atau cabang perusahaan secara instan menggunakan fitur *Analytic Accounting*.

---

## 7. Opening Balance (Saldo Awal)

### Pengertian Sederhana

**Opening Balance** adalah **saldo awal** yang Anda masukkan ke sistem baru ketika pertama kali mulai menggunakan software akuntansi.

Bayangkan Anda pindah dari buku catatan manual (atau Excel) ke Odoo. Perusahaan Anda tidak mulai dari nol — sudah ada uang di bank, stok barang di gudang, piutang pelanggan yang belum dibayar, dan utang ke supplier. Semua angka yang sudah ada ini harus "dipindahkan" ke Odoo sebagai titik awal. Itulah Opening Balance.

### Analogi Sederhana

Bayangkan Anda ganti HP baru. Kontak lama, foto, dan chat harus dipindahkan dulu ke HP baru agar Anda tidak mulai dari kosong. Opening Balance adalah proses "pindah data keuangan" ke sistem baru.

### Apa Saja yang Perlu Diinput sebagai Saldo Awal?

| Kategori | Contoh Data yang Harus Diinput |
|:---|:---|
| **Kas & Bank** | Saldo rekening bank per tanggal cut-off |
| **Piutang (Receivable)** | Daftar pelanggan yang masih punya tagihan belum bayar |
| **Persediaan (Inventory)** | Jumlah dan nilai stok barang yang ada di gudang |
| **Aset Tetap** | Daftar aset beserta nilai buku saat ini (setelah penyusutan) |
| **Hutang (Payable)** | Daftar supplier yang masih harus dibayar |
| **Pinjaman** | Sisa pinjaman bank yang belum lunas |
| **Modal & Laba Ditahan** | Akumulasi modal pemilik dan laba dari periode sebelumnya |

### Kenapa Opening Balance Penting?

1. **Laporan keuangan akan salah** jika saldo awal tidak diinput — karena Odoo menghitung saldo akhir berdasarkan: Saldo Awal + Transaksi Berjalan = Saldo Akhir
2. **Piutang dan hutang tidak akan terlihat** — tim Collection tidak tahu siapa yang belum bayar, tim Finance tidak tahu supplier mana yang harus dilunasi
3. **Stok barang tidak akurat** — tim Gudang bisa oversell karena sistem menunjukkan stok nol padahal sebenarnya ada barang
4. **Rekonsiliasi bank gagal** — saldo di Odoo tidak cocok dengan saldo di mutasi bank yang sebenarnya

### Prinsip Opening Balance

Opening Balance juga harus mengikuti prinsip keseimbangan:

```
Total Debet Saldo Awal = Total Kredit Saldo Awal
```

Artinya, semua saldo awal yang diinput harus seimbang. Jika Anda memasukkan aset (debet), harus ada sumber dananya juga di sisi kredit (hutang atau modal).

### Contoh Kasus

PT Maju Jaya mulai menggunakan Odoo per **1 Januari 2026**. Data keuangan per 31 Desember 2025:

| Akun | Debet | Kredit |
|:---|:---|:---|
| Kas | Rp 5.000.000 | |
| Bank BCA | Rp 45.000.000 | |
| Piutang Pelanggan | Rp 20.000.000 | |
| Persediaan Barang | Rp 30.000.000 | |
| Kendaraan Operasional | Rp 80.000.000 | |
| Akum. Penyusutan Kendaraan | | Rp 20.000.000 |
| Hutang Supplier | | Rp 25.000.000 |
| Pinjaman Bank | | Rp 50.000.000 |
| Modal Pemilik | | Rp 60.000.000 |
| Laba Ditahan | | Rp 25.000.000 |
| **Total** | **Rp 180.000.000** | **Rp 180.000.000** |

Semua angka ini diinput ke Odoo sebagai opening balance, dan menjadi titik awal pencatatan di sistem baru.

### Kapan Opening Balance Dilakukan?

- Biasanya di **awal tahun fiskal** (1 Januari) agar lebih rapi
- Atau di **awal bulan** tertentu saat go-live Odoo
- Tanggal ini disebut **cut-off date** — semua transaksi sebelum tanggal ini masuk sebagai saldo awal, transaksi setelahnya dicatat normal di Odoo

> **Odoo 19 Context:**
> Odoo 19 menyediakan fitur khusus untuk input opening balance melalui menu **Accounting > Configuration > Opening Balances** atau melalui journal entry khusus bertipe *Opening/Closing*. Untuk piutang dan hutang, Anda bisa import detail per customer/vendor agar aging report (laporan umur piutang/hutang) langsung akurat sejak hari pertama. Untuk inventory, opening stock diinput melalui modul Inventory dengan fitur *Inventory Adjustment*.

---

## 8. Flow Transaksi di Odoo 19: Pembelian & Penjualan

Dalam operasional sehari-hari, dua aktivitas utama perusahaan dagang/manufaktur adalah **membeli barang** dan **menjual barang**. Di Odoo 19, kedua proses ini memiliki alur yang jelas. Pencatatan akuntansi (jurnal) hanya terjadi di tahap validasi dokumen keuangan (Vendor Bill / Customer Invoice), bukan di setiap langkah.

---

### A. Flow Pembelian Barang

```
┌─────────────┐       ┌─────────────┐       ┌─────────────────┐
│  Purchase   │       │   Warehouse │       │  Vendor Bill    │
│  Order (PO) │ ───>  │   Receipt   │ ───>  │  (Tagihan dari  │
│             │       │   (WH/IN)   │       │   Supplier)     │
└─────────────┘       └─────────────┘       └─────────────────┘
   Tim Purchasing        Tim Gudang            Tim Finance/AP
```

#### Langkah 1: Purchase Order (PO)

**Siapa:** Tim Purchasing
**Apa yang terjadi:** Membuat pesanan pembelian ke supplier (vendor).

- Berisi: nama supplier, daftar barang yang dipesan, jumlah, harga, dan tanggal pengiriman
- Setelah di-confirm, PO menjadi komitmen resmi perusahaan untuk membeli
- **Dampak akuntansi:** Belum ada jurnal. PO hanya dokumen perencanaan

#### Langkah 2: Warehouse Receipt (WH/IN)

**Siapa:** Tim Gudang / Warehouse
**Apa yang terjadi:** Barang datang dari supplier dan diterima di gudang.

- Tim gudang memvalidasi bahwa barang yang datang sesuai dengan PO (jumlah, kondisi)
- Setelah di-validate, stok barang di sistem bertambah (kuantitas)
- **Dampak akuntansi:** Belum ada jurnal. Di Odoo 19, pengakuan nilai persediaan dilakukan saat Vendor Bill divalidasi, bukan saat barang diterima

#### Langkah 3: Vendor Bill (Tagihan Supplier)

**Siapa:** Tim Finance / Accounts Payable
**Apa yang terjadi:** Mencatat tagihan resmi dari supplier sekaligus mengakui penambahan nilai persediaan.

- Dibuat berdasarkan invoice/faktur yang diterima dari supplier
- Setelah di-validate, muncul kewajiban bayar (hutang) **dan** nilai persediaan tercatat di sistem
- Ini adalah satu-satunya langkah yang menghasilkan jurnal di flow pembelian
- **Dampak akuntansi:**

| Akun | Debet | Kredit | Penjelasan |
|:---|:---|:---|:---|
| Persediaan (Inventory) | Rp xxx | | Nilai stok barang bertambah |
| Hutang Usaha (Accounts Payable) | | Rp xxx | Hutang ke supplier tercatat |

#### Pembayaran ke Supplier (Opsional — saat jatuh tempo)

| Akun | Debet | Kredit | Penjelasan |
|:---|:---|:---|:---|
| Hutang Usaha (Accounts Payable) | Rp xxx | | Hutang lunas |
| Bank | | Rp xxx | Uang keluar dari bank |

#### Ringkasan Alur Pembelian

| Tahap | Dokumen | Tim | Dampak di Sistem |
|:---|:---|:---|:---|
| 1 | Purchase Order | Purchasing | Pesanan tercatat, belum ada jurnal |
| 2 | WH/IN (Receipt) | Gudang | Kuantitas stok bertambah, belum ada jurnal |
| 3 | Vendor Bill | Finance | Jurnal dibuat: persediaan (debet) & hutang (kredit) tercatat |
| 4 | Payment | Finance | Hutang lunas, uang di bank berkurang |

---

### B. Flow Penjualan Barang

```
┌─────────────┐       ┌─────────────┐       ┌─────────────────┐
│   Sales     │       │   Warehouse │       │  Customer       │
│  Order (SO) │ ───>  │   Delivery  │ ───>  │  Invoice        │
│             │       │   (WH/OUT)  │       │  (Faktur Jual)  │
└─────────────┘       └─────────────┘       └─────────────────┘
    Tim Sales            Tim Gudang            Tim Finance/AR
```

#### Langkah 1: Sales Order (SO)

**Siapa:** Tim Sales
**Apa yang terjadi:** Membuat pesanan penjualan dari pelanggan (customer).

- Berisi: nama pelanggan, daftar barang yang dipesan, jumlah, harga jual, dan syarat pembayaran
- Setelah di-confirm, SO menjadi komitmen perusahaan untuk mengirim barang
- **Dampak akuntansi:** Belum ada jurnal. SO hanya dokumen perencanaan

#### Langkah 2: Warehouse Delivery (WH/OUT)

**Siapa:** Tim Gudang / Warehouse
**Apa yang terjadi:** Barang dikirim keluar dari gudang ke pelanggan.

- Tim gudang menyiapkan (pick) dan mengirim barang sesuai SO
- Setelah di-validate, kuantitas stok barang di sistem berkurang
- **Dampak akuntansi:** Belum ada jurnal. Di Odoo 19, pengakuan pendapatan dan pengurangan nilai persediaan dilakukan saat Customer Invoice divalidasi, bukan saat barang dikirim

#### Langkah 3: Customer Invoice (Faktur Penjualan)

**Siapa:** Tim Finance / Accounts Receivable
**Apa yang terjadi:** Menerbitkan faktur tagihan ke pelanggan sekaligus mengakui pendapatan dan harga pokok penjualan.

- Dibuat berdasarkan barang yang sudah dikirim
- Setelah di-validate, muncul hak tagih (piutang), pendapatan tercatat, dan nilai persediaan berkurang
- Ini adalah satu-satunya langkah yang menghasilkan jurnal di flow penjualan
- **Dampak akuntansi:**

| Akun | Debet | Kredit | Penjelasan |
|:---|:---|:---|:---|
| Piutang Usaha (Accounts Receivable) | Rp xxx | | Hak tagih ke pelanggan |
| Pendapatan Penjualan | | Rp xxx | Pendapatan tercatat |
| Harga Pokok Penjualan (COGS) | Rp xxx | | Beban atas barang yang dijual |
| Persediaan (Inventory) | | Rp xxx | Nilai stok barang berkurang |

#### Penerimaan Pembayaran dari Pelanggan (Opsional — saat pelanggan bayar)

| Akun | Debet | Kredit | Penjelasan |
|:---|:---|:---|:---|
| Bank | Rp xxx | | Uang masuk ke bank |
| Piutang Usaha (Accounts Receivable) | | Rp xxx | Piutang lunas |

#### Ringkasan Alur Penjualan

| Tahap | Dokumen | Tim | Dampak di Sistem |
|:---|:---|:---|:---|
| 1 | Sales Order | Sales | Pesanan tercatat, belum ada jurnal |
| 2 | WH/OUT (Delivery) | Gudang | Kuantitas stok berkurang, belum ada jurnal |
| 3 | Customer Invoice | Finance | Jurnal dibuat: piutang, pendapatan, COGS & persediaan tercatat |
| 4 | Payment | Finance | Piutang lunas, uang di bank bertambah |

---

### C. Perbandingan Kedua Flow

| Aspek | Pembelian | Penjualan |
|:---|:---|:---|
| Order | Purchase Order (PO) | Sales Order (SO) |
| Pergerakan Barang | Masuk ke gudang (WH/IN) | Keluar dari gudang (WH/OUT) |
| Dokumen Keuangan | Vendor Bill (kita yang bayar) | Customer Invoice (kita yang tagih) |
| Stok | Bertambah | Berkurang |
| Kewajiban/Hak | Hutang ke supplier | Piutang dari pelanggan |

### Poin Penting untuk Tim Operasional

1. **Tim Purchasing:** Pastikan PO akurat (harga, jumlah, supplier) — ini jadi dasar pencocokan dengan vendor bill
2. **Tim Gudang:** Validasi penerimaan/pengiriman tepat waktu — keterlambatan validasi membuat laporan stok tidak akurat
3. **Tim Sales:** Pastikan SO lengkap (produk, harga, customer) — ini jadi dasar invoice
4. **Semua tim:** Meskipun jurnal hanya tercipta di tahap Bill/Invoice, setiap langkah sebelumnya (PO, Receipt, SO, Delivery) menjadi dasar data untuk jurnal tersebut — jadi akurasi di setiap tahap tetap krusial

> **Odoo 19 Context:**
> Di Odoo 19, ketiga langkah ini terintegrasi penuh antar modul (Purchase ↔ Inventory ↔ Accounting, dan Sales ↔ Inventory ↔ Accounting). Anda tidak perlu input data berulang — PO yang di-confirm otomatis membuat draft receipt di gudang, dan receipt yang di-validate bisa langsung di-convert menjadi vendor bill. Begitu juga SO yang di-confirm otomatis membuat delivery order, dan setelah barang terkirim bisa langsung generate customer invoice.

---

## 9. Bagaimana Semuanya Terhubung (Alur Besar)

### Alur Kerja Keuangan

```
[Transaksi Bisnis Terjadi]
        │
        ▼
[Dicatat ke Jurnal (Journal Entry)]
        │
        ▼
[Masuk ke Akun COA yang Tepat]
        │
        ├──────────────────────────────────┐
        ▼                                  ▼
[Laporan LABA RUGI]                 [Laporan NERACA]
(Pendapatan vs Beban)               (Aset, Utang, Modal)
```

### Alur di Odoo 19

```
[Tim Purchasing membuat PO]
[Tim Sales membuat SO]               ──>  Dokumen perencanaan (belum ada jurnal)
[Tim Gudang validate Receipt/Delivery]        │
                                              ▼
                                    [Kuantitas stok ter-update]
                                              │
                                              ▼
[Tim Finance validate Bill/Invoice]  ──>  Odoo otomatis membuat Journal Entry
                                              │
                                              ▼
                                    [Masuk ke akun COA yang sesuai]
                                              │
                                              ▼
                                    [Laporan keuangan ter-update real-time]
```

---

## 10. Contoh Cerita Lengkap: Toko Elektronik "Maju Jaya"

Berikut simulasi transaksi selama 3 hari untuk menggambarkan bagaimana semua konsep di atas saling terhubung.

### Hari 1 — Pemilik Setor Modal

Pemilik menaruh modal tunai Rp 10.000.000 ke bisnis.

| Akun | Debet | Kredit | Penjelasan |
|:---|:---|:---|:---|
| Kas | Rp 10.000.000 | | Uang (aset) bertambah |
| Modal Pemilik | | Rp 10.000.000 | Modal bertambah |

### Hari 2 — Beli Barang Dagangan

Toko beli stok barang Rp 3.000.000 secara tunai.

| Akun | Debet | Kredit | Penjelasan |
|:---|:---|:---|:---|
| Persediaan Barang | Rp 3.000.000 | | Stok (aset) bertambah |
| Kas | | Rp 3.000.000 | Uang (aset) berkurang |

### Hari 3 — Jual Barang ke Pelanggan

Toko berhasil menjual barang seharga Rp 5.000.000 secara tunai.

| Akun | Debet | Kredit | Penjelasan |
|:---|:---|:---|:---|
| Kas | Rp 5.000.000 | | Uang (aset) bertambah |
| Penjualan | | Rp 5.000.000 | Pendapatan bertambah |

### Hasil Setelah 3 Hari

**Neraca (posisi keuangan):**
- Kas: Rp 12.000.000 (10jt - 3jt + 5jt)
- Persediaan: Rp 3.000.000
- Total Aset: Rp 15.000.000
- Modal + Laba: Rp 15.000.000

**Laba Rugi (kinerja):**
- Pendapatan: Rp 5.000.000
- Beban: Rp 0
- Laba: Rp 5.000.000

Semua tercatat rapi dan seimbang!

---

## Ringkasan

| Istilah | Penjelasan Singkat |
|:---|:---|
| **COA** | Daftar/struktur seluruh akun keuangan perusahaan |
| **Aset** | Harta/sumber daya yang dimiliki perusahaan |
| **Debet & Kredit** | Mekanisme pencatatan dua sisi (kiri & kanan) |
| **Journal Entry** | Catatan transaksi harian yang menjadi sumber laporan |
| **Neraca** | Laporan posisi keuangan pada satu titik waktu |
| **Laba Rugi** | Laporan kinerja (untung/rugi) selama periode tertentu |
| **Opening Balance** | Saldo awal yang diinput saat pertama kali menggunakan sistem baru |
| **Flow Pembelian** | PO → WH/IN → Vendor Bill → Payment (jurnal di Vendor Bill) |
| **Flow Penjualan** | SO → WH/OUT → Customer Invoice → Payment (jurnal di Invoice) |

---

## Penutup

Dengan memahami konsep-konsep dasar ini, pengguna Odoo dari divisi manapun akan paham mengapa pengisian data operasional (seperti harga barang, tanggal terima barang, dan status bayar) yang akurat sangat krusial bagi keandalan laporan keuangan perusahaan.

Anda tidak perlu menjadi akuntan. Yang penting:
1. Pahami bahwa setiap data yang Anda input punya dampak ke keuangan
2. Pastikan data yang diinput akurat dan tepat waktu
3. Biarkan Odoo 19 yang mengurus pencatatan jurnal dan pembuatan laporan secara otomatis

Selamat belajar dan selamat praktik di Odoo 19!
