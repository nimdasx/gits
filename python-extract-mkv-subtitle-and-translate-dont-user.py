# python3 -m venv venv
# source venv/bin/activate
# pip install deep-translator langdetect
# yang ini jangan dipakai

import os
import json
import subprocess
from pathlib import Path
from deep_translator import GoogleTranslator


# ----------------- Helper bahasa -----------------

def normalize_lang(user_input):
    """
    Terima input bebas seperti:
    'english', 'eng', 'en', 'indonesia', 'id', 'ind', dll.
    Kembalikan:
      - kode 2 huruf (untuk translator)
      - set kode yang bisa dipakai untuk cocokin tag ffmpeg
    """
    u = user_input.strip().lower()

    # mapping sederhana
    mapping = {
        "english": ("en", {"en", "eng", "english"}),
        "eng": ("en", {"en", "eng", "english"}),
        "en": ("en", {"en", "eng", "english"}),

        "indonesia": ("id", {"id", "ind", "indonesian", "indonesia", "indo"}),
        "indonesian": ("id", {"id", "ind", "indonesian", "indonesia", "indo"}),
        "indo": ("id", {"id", "ind", "indonesian", "indonesia", "indo"}),
        "id": ("id", {"id", "ind", "indonesian", "indonesia", "indo"}),
        "ind": ("id", {"id", "ind", "indonesian", "indonesia", "indo"}),

        "japanese": ("ja", {"ja", "jpn", "japanese", "japan"}),
        "japan": ("ja", {"ja", "jpn", "japanese", "japan"}),
        "ja": ("ja", {"ja", "jpn"}),
        "jpn": ("ja", {"ja", "jpn"}),

        "korean": ("ko", {"ko", "kor", "korean"}),
        "ko": ("ko", {"ko", "kor"}),
        "kor": ("ko", {"ko", "kor"}),

        "spanish": ("es", {"es", "spa", "spanish"}),
        "es": ("es", {"es", "spa"}),
        "spa": ("es", {"es", "spa"}),

        "french": ("fr", {"fr", "fre", "fra", "french"}),
        "fr": ("fr", {"fr", "fre", "fra"}),
        "fra": ("fr", {"fr", "fre", "fra"}),
        "fre": ("fr", {"fr", "fre", "fra"}),

        "german": ("de", {"de", "ger", "deu", "german"}),
        "de": ("de", {"de", "ger", "deu"}),
        "ger": ("de", {"de", "ger", "deu"}),
        "deu": ("de", {"de", "ger", "deu"}),
    }

    if u in mapping:
        return mapping[u]

    # fallback: kalau user isi kode 2/3 huruf lain (mis. 'ru', 'pt', dll)
    if len(u) in (2, 3):
        return u, {u}

    # fallback terakhir: pakai apa adanya
    return u, {u}


# ----------------- ffprobe & ffmpeg -----------------

def get_subtitle_stream_for_lang(mkv_path, lang_match_set):
    """
    Mengambil stream subtitle yang bahasanya cocok dengan lang_match_set.
    Kembalikan dict stream pertama yang cocok, atau None kalau tidak ada.
    """
    cmd = [
        "ffprobe",
        "-v", "error",
        "-select_streams", "s",  # hanya subtitle streams
        "-show_entries", "stream=index:stream_tags=language,title",
        "-of", "json",
        str(mkv_path)
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"[WARN] ffprobe gagal untuk: {mkv_path.name}")
        return None

    data = json.loads(result.stdout or "{}")
    streams = data.get("streams", [])

    for stream in streams:
        tags = stream.get("tags", {}) or {}
        lang_tag = (tags.get("language") or "").lower()
        if lang_tag in lang_match_set:
            return stream

    return None


def extract_subtitle_to_srt(mkv_path, stream, out_srt_path):
    """
    Extract satu stream subtitle ke file .srt menggunakan ffmpeg.
    """
    stream_index = stream["index"]  # global index di file mkv

    cmd = [
        "ffmpeg",
        "-y",  # overwrite tanpa tanya
        "-i", str(mkv_path),
        "-map", f"0:{stream_index}",
        "-c:s", "srt",          # pastikan format output srt
        str(out_srt_path)
    ]

    print(f"  -> Extract stream {stream_index} ke {out_srt_path.name}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"     [ERROR] ffmpeg gagal extract subtitle dari {mkv_path.name}")
        print("     stderr:", result.stderr.splitlines()[-1:])


# ----------------- Translate SRT -----------------

def translate_srt_file(input_srt, output_srt, source_code, target_code):
    """
    Translate baris teks di file SRT dari source_code ke target_code.
    Nomor & timestamp tidak diubah.
    """
    translator = GoogleTranslator(source=source_code, target=target_code)

    with open(input_srt, "r", encoding="utf-8") as f:
        lines = f.readlines()

    translated_lines = []

    for line in lines:
        stripped = line.strip()

        # baris kosong
        if stripped == "":
            translated_lines.append(line)
        # nomor atau timestamp
        elif stripped.isdigit() or "-->" in stripped:
            translated_lines.append(line)
        else:
            try:
                translated_text = translator.translate(stripped)
            except Exception as e:
                print(f"     [WARN] Gagal translate baris: {stripped}")
                print("           Error:", e)
                translated_text = stripped  # fallback: pakai teks asli

            translated_lines.append(translated_text + "\n")

    with open(output_srt, "w", encoding="utf-8") as f:
        f.writelines(translated_lines)

    print(f"  -> Subtitle terjemahan disimpan: {output_srt.name}")


# ----------------- Main Flow -----------------

def main():
    folder_input = input("Masukkan path folder yang berisi file .mkv: ").strip().strip('"')
    folder = Path(folder_input)

    if not folder.exists() or not folder.is_dir():
        print("❌ Folder tidak ditemukan / bukan folder.")
        return

    src_lang_input = input("Masukkan bahasa subtitle sumber (mis. english, eng, en): ")
    tgt_lang_input = input("Masukkan bahasa tujuan (mis. indonesia, id): ")

    src_code, src_match_set = normalize_lang(src_lang_input)
    tgt_code, _ = normalize_lang(tgt_lang_input)

    print(f"\nBahasa sumber di subtitle MKV  : {src_lang_input} -> match tags {src_match_set}")
    print(f"Bahasa sumber untuk translator : {src_code}")
    print(f"Bahasa tujuan untuk translator : {tgt_code}")

    mkv_files = sorted(folder.glob("*.mkv"))
    if not mkv_files:
        print("❌ Tidak ada file .mkv di folder tersebut.")
        return

    out_dir = folder / "translated_subs"
    out_dir.mkdir(exist_ok=True)

    print(f"\nDitemukan {len(mkv_files)} file .mkv.")
    print(f"Hasil subtitle terjemahan akan disimpan di: {out_dir}\n")

    for mkv_path in mkv_files:
        print(f"Memproses: {mkv_path.name}")

        stream = get_subtitle_stream_for_lang(mkv_path, src_match_set)
        if not stream:
            print(f"  ⚠ Tidak ditemukan subtitle dengan bahasa {src_match_set} di file ini.")
            continue

        base_name = mkv_path.stem

        # file sementara untuk subtitle sumber
        src_srt_path = out_dir / f"{base_name}_src_{src_code}.srt"
        translated_srt_path = out_dir / f"{base_name}_{src_code}_to_{tgt_code}.srt"

        extract_subtitle_to_srt(mkv_path, stream, src_srt_path)
        translate_srt_file(src_srt_path, translated_srt_path, source_code=src_code, target_code=tgt_code)

    print("\n✅ Selesai memproses semua file .mkv.")


if __name__ == "__main__":
    main()
