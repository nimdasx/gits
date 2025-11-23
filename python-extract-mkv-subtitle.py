# sudo apt install ffmpeg
# python python-extract-mkv-subtitle.py

import os
import subprocess
import json
from pathlib import Path

def get_subtitle_streams(mkv_path):
    """
    Menggunakan ffprobe untuk mengambil daftar stream subtitle
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
        print(f"[WARN] Gagal ffprobe: {mkv_path.name}")
        return []

    data = json.loads(result.stdout)
    return data.get("streams", [])


def extract_subtitle(mkv_path, stream, out_dir):
    """
    Extract + convert stream subtitle ke .srt dengan ffmpeg
    """
    stream_index = stream["index"]           # index global stream di file
    tags = stream.get("tags", {}) or {}
    lang = tags.get("language", "und")       # und = undefined
    title = tags.get("title", "").strip()

    # Nama file output
    base = mkv_path.stem
    safe_title = "".join(c for c in title if c.isalnum() or c in " _-").strip()
    if safe_title:
        out_name = f"{base}.sub_{lang}_{safe_title}.srt"
    else:
        out_name = f"{base}.sub_{lang}.srt"

    out_path = out_dir / out_name

    cmd = [
        "ffmpeg",
        "-y",                 # overwrite tanpa tanya
        "-i", str(mkv_path),
        "-map", f"0:{stream_index}",  # pakai index global stream
        "-c:s", "srt",        # pastikan output format srt
        str(out_path)
    ]

    print(f"  -> Extract stream {stream_index} ({lang}, '{title}') ke {out_path.name}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"     [ERROR] ffmpeg gagal untuk stream {stream_index}")
        print("     ffmpeg stderr:", result.stderr.splitlines()[-1:])


def main():
    folder_input = input("Masukkan path folder yang berisi file .mkv: ").strip().strip('"')

    folder = Path(folder_input)
    if not folder.exists() or not folder.is_dir():
        print("Folder tidak ditemukan atau bukan folder yang valid.")
        return

    # Folder output (bisa diubah sesuai kebutuhan, sekarang: subfolder 'subs' di dalam folder yang sama)
    out_dir = folder / "subs"
    out_dir.mkdir(exist_ok=True)

    mkv_files = sorted(folder.glob("*.mkv"))

    if not mkv_files:
        print("Tidak ada file .mkv di folder tersebut.")
        return

    print(f"Ditemukan {len(mkv_files)} file .mkv")
    for mkv_path in mkv_files:
        print(f"\nMemproses: {mkv_path.name}")

        streams = get_subtitle_streams(mkv_path)
        if not streams:
            print("  Tidak ada stream subtitle ditemukan.")
            continue

        for stream in streams:
            extract_subtitle(mkv_path, stream, out_dir)

    print("\nSelesai. Semua subtitle disimpan di folder:", out_dir)


if __name__ == "__main__":
    main()
