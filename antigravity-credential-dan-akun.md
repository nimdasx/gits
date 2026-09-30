# Analisis Akun & Kredensial Google di Google Antigravity

Dokumen ini merangkum hasil investigasi dan analisis mengenai cara Google Antigravity (IDE, Desktop, dan CLI) mengelola akun Google, lokasi penyimpanan token, serta metode berganti akun (*account switching*).

---

## 1. Akun yang Sedang Aktif & Lokasi File Kredensial

### Akun Terdeteksi:
* **Email:** `akun-utama@gmail.com`
* **Nama Tampilan:** `nama-tampilan`

### Dari Mana Informasi Tersebut Dibaca?
Informasi sesi login dibaca langsung dari file token OAuth lokal:
```text
~/.gemini/antigravity-cli/antigravity-oauth-token
```
*(Path absolut: `/home/sfx/.gemini/antigravity-cli/antigravity-oauth-token`)*

### Cara Membaca / Dekode Token:
File tersebut berformat JSON yang berisi metadata OAuth dan kunci `id_token`. Nilai `id_token` merupakan standar JWT (*JSON Web Token*). Profil akun tersimpan pada bagian *payload* (segmen kedua yang di-encode Base64URL).

Dapat diperiksa menggunakan Python:
```bash
python3 -c "
import json, base64

with open('/home/sfx/.gemini/antigravity-cli/antigravity-oauth-token') as f:
    data = json.load(f)
    id_token = data.get('id_token')
    if id_token:
        payload_b64 = id_token.split('.')[1]
        payload_b64 += '=' * (4 - len(payload_b64) % 4)
        payload = json.loads(base64.urlsafe_b64decode(payload_b64))
        print('Email :', payload.get('email'))
        print('Name  :', payload.get('name'))
"
```

---

## 2. Hubungan Kredensial Antara 3 Aplikasi (IDE, Desktop, CLI)

**Jawaban Singkat:** **Ya, ketiganya membaca dan menggunakan kredensial (akun Google) yang sama secara default.**

### Mengapa Kredensialnya Bersama?
1. **Engine Backend Terpadu:**
   Baik Antigravity IDE (berbasis VS Code), Antigravity Desktop (Antigravity 2.0 / Electron), maupun Antigravity CLI (`agy`) semuanya terhubung ke daemon backend language server yang sama:
   ```text
   /home/sfx/.gemini/bin/agy
   ```
2. **Sistem Penyimpanan Token (*Composite Token Storage*):**
   Backend Antigravity menggunakan sistem penyimpanan bertingkat:
   * **OS Keyring / Secret Service:** Di Linux menggunakan KWallet / GNOME Keyring (di macOS Keychain, di Windows Credential Manager).
   * **File Fallback:** File token bersama di `~/.gemini/antigravity-cli/antigravity-oauth-token`.
3. **Pembagian Data:**
   * **Bersama (Shared):** Akun Google OAuth, konfigurasi global, rules, MCP servers, dan plugins (`~/.gemini/config/`).
   * **Terpisah (Per-App Data):** History percakapan, cache, dan state runtime tersimpan di subfoldernya masing-masing:
     * Antigravity Desktop: `~/.gemini/antigravity/`
     * Antigravity IDE: `~/.gemini/antigravity-ide/`
     * Antigravity CLI: `~/.gemini/antigravity-cli/`

---

## 3. Apakah Bisa Switch Akun Tanpa Logout & Login Ulang?

### Status Fitur Bawaan (*Native*):
Secara resmi di antarmuka (UI), **belum ada fitur multi-account profile switcher** (seperti fitur "Switch Account" pada browser Google Chrome). Antigravity saat ini dirancang untuk memegang satu sesi OAuth aktif di tingkat user OS.

### Alternatif / Solusi Praktis:

### Opsi A: Menggunakan `GEMINI_API_KEY` (Paling Direkomendasikan untuk Proyek Berbeda)
Jika Anda ingin membedakan kuota, akun penagihan (*billing*), atau lingkungan kerja vs pribadi:
1. Buat API Key dari masing-masing akun Google melalui [Google AI Studio](https://aistudio.google.com/).
2. Setel variabel lingkungan di terminal atau file `.env` proyek:
   ```bash
   export GEMINI_API_KEY="AIzaSy...kunci-akun-kedua"
   ```
3. Ketika `GEMINI_API_KEY` terdeteksi, Antigravity CLI akan memprioritaskan API Key ini dan mengabaikan sesi login OAuth utama.

---

### Opsi B: Skrip Swap File Token OAuth
Karena token disimpan dalam file lokal, Anda bisa membuat backup token dari masing-masing akun dan menukarnya tanpa perlu alur browser:

1. **Backup token akun pertama (saat ini aktif):**
   ```bash
   mkdir -p ~/.gemini/saved_tokens
   cp ~/.gemini/antigravity-cli/antigravity-oauth-token ~/.gemini/saved_tokens/token_akun_1
   ```

2. **Logout dan Login sekali ke akun kedua lewat browser, lalu simpan:**
   ```bash
   cp ~/.gemini/antigravity-cli/antigravity-oauth-token ~/.gemini/saved_tokens/token_akun_2
   ```

3. **Buat fungsi switcher di `~/.bashrc`:**
   ```bash
   switch_agy() {
     case "$1" in
       1)
         cp ~/.gemini/saved_tokens/token_akun_1 ~/.gemini/antigravity-cli/antigravity-oauth-token
         echo ">> Berpindah ke Akun 1 (akun-utama...)"
         ;;
       2)
         cp ~/.gemini/saved_tokens/token_akun_2 ~/.gemini/antigravity-cli/antigravity-oauth-token
         echo ">> Berpindah ke Akun 2"
         ;;
       *)
         echo "Gunakan: switch_agy 1 ATAU switch_agy 2"
         ;;
     esac
   }
   ```
   *Cukup panggil `switch_agy 1` atau `switch_agy 2`, lalu restart instance Antigravity Anda.*

---

### Opsi C: Menjalankan di Bawah User Linux Berbeda
Jika Anda ingin menjalankan dua instance secara bersamaan (misal satu di IDE untuk akun personal, satu di Desktop/terminal untuk akun kantor), jalankan aplikasi dengan user Linux terpisah, sehingga masing-masing memiliki direktori `~/.gemini/` dan Keyring tersendiri.
