from pathlib import Path
from langdetect import detect
from deep_translator import GoogleTranslator


def detect_language_from_srt(input_file, max_chars=500):
    """
    Deteksi bahasa dari isi teks subtitle (abaikan nomor & timestamp).
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
        raise ValueError("Tidak ada teks untuk deteksi bahasa.")

    sample_text = " ".join(text_parts)
    lang = detect(sample_text)
    return lang


def translate_srt(input_file, output_file, source_lang, target_lang):
    """
    Translate SRT:
    - Nomor & timestamp dipertahankan
    - Teks diterjemahkan
    - Translate per blok (lebih cepat)
    """
    translator = GoogleTranslator(source=source_lang, target=target_lang)

    with open(input_file, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    # potong menjadi blok-blok
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
    print(f"Total blok subtitle: {total_blocks}")

    translated_blocks = []

    for idx, block in enumerate(blocks, start=1):
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
                print(f"[WARN] gagal translate blok {idx}: {e}")
                translated_text = original_text
            new_text_lines = [translated_text + "\n"]
        else:
            new_text_lines = []

        translated_block = header_lines + new_text_lines
        translated_blocks.append(translated_block)

        if idx % 10 == 0 or idx == total_blocks:
            print(f"  Progres: {idx}/{total_blocks} blok")

    # tulis hasil
    with open(output_file, "w", encoding="utf-8") as f:
        for block in translated_blocks:
            for line in block:
                f.write(line)
            f.write("\n")

    print(f"\n✅ Selesai! Subtitle tersimpan sebagai:\n{output_file}")


def main():
    input_path = input("Masukkan path file .srt: ").strip().strip('"')
    srt_file = Path(input_path)

    if not srt_file.exists() or not srt_file.is_file() or not srt_file.suffix.lower() == ".srt":
        print("❌ File tidak valid / bukan .srt")
        return

    print("\n🔍 Mendeteksi bahasa subtitle...")
    try:
        detected_lang = detect_language_from_srt(srt_file)
    except Exception as e:
        print("❌ Gagal deteksi bahasa:", e)
        return

    print(f"Bahasa terdeteksi: {detected_lang}")

    target_lang = input("Masukkan kode bahasa tujuan (mis. id, en, fr): ").strip().lower()
    if not target_lang:
        print("❌ Bahasa tujuan tidak boleh kosong.")
        return

    output_file = srt_file.with_name(f"{srt_file.stem}_{detected_lang}_to_{target_lang}.srt")

    print(f"\n🚀 Menerjemahkan subtitle...")
    translate_srt(srt_file, output_file, detected_lang, target_lang)


if __name__ == "__main__":
    main()
