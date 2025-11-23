# yang ini jangan dipakai

import os
from pathlib import Path
from langdetect import detect
from deep_translator import GoogleTranslator


def detect_language_from_srt(input_file, max_chars=500):
    """
    Deteksi bahasa dari isi teks subtitle (abaikan nomor & timestamp).
    Hanya ambil sebagian teks (max_chars) supaya cepat.
    """
    with open(input_file, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    text_parts = []
    total_len = 0

    for line in lines:
        s = line.strip()
        if not s:
            continue
        if s.isdigit():
            continue
        if "-->" in s:
            continue

        text_parts.append(s)
        total_len += len(s)

        if total_len >= max_chars:
            break

    if not text_parts:
        raise ValueError("Tidak ada teks yang bisa dipakai untuk deteksi bahasa.")

    sample_text = " ".join(text_parts)
    lang = detect(sample_text)
    return lang


def translate_srt(input_file, output_file, source_lang="en", target_lang="id"):
    """
    Translate SRT: hanya teks yang diterjemahkan.
    Nomor & timestamp tetap.
    """
    translator = GoogleTranslator(source=source_lang, target=target_lang)

    with open(input_file, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    translated_lines = []
    buffer_text = []

    def flush_buffer():
        nonlocal buffer_text
        if not buffer_text:
            return
        combined = " ".join(buffer_text)
        try:
            translated = translator.translate(combined)
        except Exception as e:
            print(f"    [WARN] Gagal translate block: {combined[:50]}...")
            print("          Error:", e)
            translated = combined  # fallback

        # pecah ke beberapa baris lagi (sederhana, 1 baris per blok)
        translated_lines.append(translated + "\n")
        buffer_text = []

    for line in lines:
        s = line.strip()

        # akhir blok
        if s == "":
            flush_buffer()
            translated_lines.append("\n")
        # nomor atau timestamp
        elif s.isdigit() or "-->" in s:
            flush_buffer()
            translated_lines.append(line)
        else:
            buffer_text.append(s)

    # kalau masih ada sisa teks di buffer (tanpa newline terakhir)
    flush_buffer()

    with open(output_file, "w", encoding="utf-8") as f:
        f.writelines(translated_lines)

    print(f"    -> Disimpan: {output_file}")


def main():
    folder_input = input("Masukkan path folder yang berisi file .srt: ").strip().strip('"')
    src_lang_code = input("Masukkan kode bahasa sumber (mis. en): ").strip().lower()
    tgt_lang_code = input("Masukkan kode bahasa tujuan (mis. id): ").strip().lower()

    folder = Path(folder_input)
    if not folder.exists() or not folder.is_dir():
        print("❌ Folder tidak ditemukan / bukan folder.")
        return

    srt_files = sorted(folder.glob("*.srt"))
    if not srt_files:
        print("❌ Tidak ada file .srt di folder tersebut.")
        return

    out_dir = folder / "translated"
    out_dir.mkdir(exist_ok=True)

    print(f"\nDitemukan {len(srt_files)} file .srt.")
    print(f"Hanya file dengan bahasa terdeteksi = '{src_lang_code}' yang akan diterjemahkan.")
    print(f"Hasil terjemahan akan disimpan di: {out_dir}\n")

    for srt_path in srt_files:
        print(f"Memproses: {srt_path.name}")
        try:
            detected = detect_language_from_srt(srt_path)
            print(f"  Bahasa terdeteksi: {detected}")
        except Exception as e:
            print(f"  [WARN] Gagal deteksi bahasa: {e}")
            continue

        if detected != src_lang_code:
            print(f"  >> Skip (bukan {src_lang_code})")
            continue

        out_name = f"{srt_path.stem}_{src_lang_code}_to_{tgt_lang_code}.srt"
        out_path = out_dir / out_name

        translate_srt(srt_path, out_path, source_lang=src_lang_code, target_lang=tgt_lang_code)

    print("\n✅ Selesai memproses semua file .srt.")


if __name__ == "__main__":
    main()
