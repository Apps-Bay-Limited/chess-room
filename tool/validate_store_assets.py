#!/usr/bin/env python3
"""Validate prepared store copy and native screenshots without editing images."""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import zlib

ROOT = Path(__file__).resolve().parents[1]
LIMITS = {"title": 30, "subtitle": 30, "promotional_text": 170,
          "keywords": 100, "description": 4000, "release_notes": 4000,
          "google_play_short_description": 80}
LOCALES = {"en-US", "ar-SA", "es-ES", "fr-FR", "ja", "zh-Hans", "zh-Hant"}
COMMON_FIELDS = set(LIMITS) - {"google_play_short_description"}
EXPECTED_METADATA = {f"{locale}/{field}.txt"
                     for locale in LOCALES for field in COMMON_FIELDS}
EXPECTED_METADATA.add("en-US/google_play_short_description.txt")
FAMILIES = {"iphone", "ipad", "android"}
CAPTURES = {"01-quick-play.png", "02-play-offline.png", "03-continue-game.png",
            "04-daily-practice.png", "05-learn-from-solutions.png"}
IPHONE = {(1320, 2868), (1290, 2796), (1284, 2778), (1242, 2688)}
IPAD = {(2064, 2752), (2048, 2732)}


def inspect_png(data):
    """Check the PNG chunk stream and CRCs, without changing the native image."""
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise ValueError("invalid PNG signature")
    offset = 8
    header = None
    saw_idat = False
    saw_palette = False
    has_transparency_chunk = False
    while offset < len(data):
        if len(data) - offset < 12:
            raise ValueError("truncated PNG chunk")
        length, kind = struct.unpack(">I4s", data[offset:offset + 8])
        end = offset + 12 + length
        if end > len(data):
            raise ValueError("truncated PNG chunk payload")
        payload = data[offset + 8:offset + 8 + length]
        expected_crc = struct.unpack(">I", data[end - 4:end])[0]
        if zlib.crc32(kind + payload) & 0xffffffff != expected_crc:
            raise ValueError(f"invalid {kind!r} PNG chunk CRC")
        if header is None and kind != b"IHDR":
            raise ValueError("IHDR must be the first PNG chunk")
        if kind == b"IHDR":
            if header is not None or length != 13:
                raise ValueError("invalid or duplicate IHDR")
            header = struct.unpack(">IIBBBBB", payload)
            width, height, depth, color, compression, filtering, interlace = header
            depths = {0: {1, 2, 4, 8, 16}, 2: {8, 16}, 3: {1, 2, 4, 8},
                      4: {8, 16}, 6: {8, 16}}
            if (width == 0 or height == 0 or depth not in depths.get(color, set())
                    or compression != 0 or filtering != 0 or interlace not in (0, 1)):
                raise ValueError("invalid PNG image header")
        elif kind == b"PLTE":
            if not payload or length % 3 or length > 768 or saw_idat:
                raise ValueError("invalid PNG palette")
            saw_palette = True
        elif kind == b"tRNS":
            has_transparency_chunk = True
        elif kind == b"IDAT":
            saw_idat = True
        elif kind == b"IEND":
            if length != 0 or not saw_idat or end != len(data):
                raise ValueError("invalid PNG ending or missing image data")
            if header[3] == 3 and not saw_palette:
                raise ValueError("indexed PNG is missing its palette")
            return {"width": header[0], "height": header[1],
                    "bit_depth": header[2], "color_type": header[3],
                    "has_transparency_chunk": has_transparency_chunk}
        offset = end
    raise ValueError("PNG is missing IEND")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--require-screenshots", action="store_true")
    args = parser.parse_args()
    failures = []
    metadata_root = ROOT / "store/metadata"
    metadata = sorted(metadata_root.glob("*/*.txt"))
    actual_metadata = {str(path.relative_to(metadata_root)) for path in metadata}
    for missing in sorted(EXPECTED_METADATA - actual_metadata):
        failures.append(f"Missing metadata/{missing}")
    for unexpected in sorted(actual_metadata - EXPECTED_METADATA):
        failures.append(f"Unexpected metadata/{unexpected}")
    for path in metadata:
        raw = path.read_text(encoding="utf-8")
        value = raw[:-1] if raw.endswith("\n") else raw
        limit = LIMITS.get(path.stem)
        if limit is not None and (not value.strip() or len(value) > limit):
            failures.append(f"{path.relative_to(ROOT)}: {len(value)} characters (limit {limit})")
    screenshots = []
    screenshot_root = ROOT / "store/screenshots"
    capture_counts = {family: {} for family in FAMILIES}
    for path in sorted(screenshot_root.rglob("*.png")):
        data = path.read_bytes()
        try:
            details = inspect_png(data)
        except ValueError as error:
            failures.append(f"{path.relative_to(ROOT)}: {error}")
            continue
        relative = path.relative_to(screenshot_root)
        family = relative.parts[0]
        width, height = details["width"], details["height"]
        if family == "iphone" and (width, height) not in IPHONE:
            failures.append(f"{path}: unsupported large iPhone dimensions {width}x{height}")
        if family == "ipad" and (width, height) not in IPAD:
            failures.append(f"{path}: unsupported 13-inch iPad dimensions {width}x{height}")
        if family == "android":
            if min(width, height) < 320 or max(width, height) > 3840 or max(width, height) > 2 * min(width, height):
                failures.append(f"{path}: Google Play screenshots require 320–3840px dimensions with aspect ratio at most 2:1")
            if details["color_type"] != 2 or details["bit_depth"] != 8:
                failures.append(f"{path}: Google Play PNG screenshots must use 24-bit RGB encoding")
        if family in FAMILIES and (
                details["color_type"] in (4, 6) or details["has_transparency_chunk"]):
            failures.append(f"{path}: Store screenshots must not contain an alpha channel or tRNS transparency")
        if family in FAMILIES:
            counts = capture_counts[family]
            counts[path.name] = counts.get(path.name, 0) + 1
        elif args.require_screenshots:
            failures.append(f"{path}: screenshot must be under iphone/, ipad/, or android/")
        screenshots.append({"file": str(path.relative_to(ROOT)), **details,
                            "sha256": hashlib.sha256(data).hexdigest()})
    if args.require_screenshots:
        for family in sorted(FAMILIES):
            counts = capture_counts[family]
            for missing in sorted(CAPTURES - counts.keys()):
                failures.append(f"Missing {family}/{missing}")
            for name, count in sorted(counts.items()):
                if name not in CAPTURES or count != 1:
                    failures.append(f"{family}/{name}: expected one planned capture, found {count}")
    if failures:
        raise SystemExit("\n".join(failures))
    manifest = {"version": "1.4.0+13", "metadata_files": len(metadata),
                "screenshots": screenshots,
                "uploaded": False, "experiment_started": False}
    (ROOT / "store/asset_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"Validated {len(metadata)} metadata files and {len(screenshots)} screenshots.")


if __name__ == "__main__":
    main()
