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
    Translate SRT:
    - Hanya teks yang diterjemahkan
    - Nomor & timestamp tetap
    - Satu request ke GoogleTranslator per blok subtitle (lebih cepat)
    """
    translator = GoogleTranslator(source=source_lang, target=target_lang)

    # 1. Baca semua baris dulu
    with open(input_file, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    # 2. Potong jadi blok-blok (1 blok = 1 subtitle)
    blocks = []
    current_block = []

    for line in lines:
        if line.strip() == "":
            if current_block:
                blocks.append(current_block)
                current_block = []
        else:
            current_block.append(line)

    if current_block:
        blocks.append(current_block)

    total_blocks = len(blocks)
    print(f"  Total blok subtitle: {total_blocks}")

    translated_blocks = []

    for idx, block in enumerate(blocks, start=1):
        # Pisahkan: nomor, timestamp, teks
        header_lines = []
        text_lines = []

        for line in block:
            s = line.strip()
            if s.isdigit() or "-->" in s:
                header_lines.append(line)
            else:
                text_lines.append(s)

        if text_lines:
            original_text = " ".join(text_lines)
            try:
                translated_text = translator.translate(original_text)
            except Exception as e:
                print(f"  [WARN] Gagal translate blok {idx}: {e}")
                translated_text = original_text  # fallback

            # Sederhana: semua hasil terjemahan di 1 baris
            new_text_lines = [translated_text + "\n"]
        else:
            new_text_lines = []

        # Susun kembali blok: header (nomor + timestamp) + teks baru
        translated_block = header_lines + new_text_lines
        translated_blocks.append(translated_block)

        if idx % 10 == 0 or idx == total_blocks:
            print(f"    Progres: {idx}/{total_blocks} blok")

    # 3. Tulis ke file output
    with open(output_file, "w", encoding="utf-8") as f:
        for block in translated_blocks:
            for line in block:
                f.write(line)
            f.write("\n")  # pemisah antar blok

    print(f"  -> Selesai translate: {output_file}")


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
