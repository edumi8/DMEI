#!/usr/bin/env python3
"""
Extract text from a PDF to a .txt file (best-effort) using PyMuPDF.
Usage:
  python3 scripts/extract_pdf_text.py --pdf "path/to/file.pdf" --out "out.txt"
"""

import argparse
from pathlib import Path

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdf", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--max-pages", type=int, default=25)  # keep it fast
    args = ap.parse_args()

    pdf_path = Path(args.pdf)
    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    try:
        import fitz  # PyMuPDF
    except Exception as e:
        raise SystemExit(
            "PyMuPDF not installed. Install with: pip install pymupdf\n"
            f"Original error: {e}"
        )

    doc = fitz.open(str(pdf_path))
    pages = min(len(doc), 100)

    chunks = []
    for i in range(pages):
        page = doc.load_page(i)
        txt = page.get_text("text")
        if txt and txt.strip():
            chunks.append(f"\n\n--- PAGE {i+1} ---\n{txt}")

    if not chunks:
        # If the PDF is scanned images, PyMuPDF won’t extract text (needs OCR)
        chunks = ["[NO_TEXT_EXTRACTED] This PDF may be scanned or image-based. Consider OCR."]

    out_path.write_text("\n".join(chunks), encoding="utf-8")
    print(f"Extracted {pages} pages -> {out_path}")

if __name__ == "__main__":
    main()
