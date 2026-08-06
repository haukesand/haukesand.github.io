#!/usr/bin/env python3
"""Convert _bibliography/papers.bib into cv/papers.json for the Typst CV.

Format per entry: author list normalised to "First Last", venue picked from
booktitle/journal, year+month kept, Hauke flagged so the template can bold him.
"""

import json
import re
from pathlib import Path

import bibtexparser

REPO = Path(__file__).resolve().parent.parent
BIB = REPO / "_bibliography" / "papers.bib"
OUT = REPO / "cv" / "papers.json"

MONTHS = {
    "jan": "January", "feb": "February", "mar": "March", "apr": "April",
    "may": "May", "jun": "June", "jul": "July", "aug": "August",
    "sep": "September", "oct": "October", "nov": "November", "dec": "December",
}


def flip_name(raw: str) -> str:
    raw = raw.strip()
    if "," in raw:
        last, first = [s.strip() for s in raw.split(",", 1)]
        return f"{first} {last}"
    return raw


def strip_braces(s: str) -> str:
    return re.sub(r"[{}]", "", s or "").strip()


def parse_entry(e: dict) -> dict:
    authors_raw = e.get("author", "")
    authors = [flip_name(a) for a in re.split(r"\s+and\s+", authors_raw)]
    is_hauke = [
        "hauke" in a.lower() and "sandhaus" in a.lower() for a in authors
    ]
    venue = e.get("booktitle") or e.get("journal") or e.get("school") or ""
    month = MONTHS.get((e.get("month") or "").lower()[:3], e.get("month", ""))
    return {
        "key": e.get("ID", ""),
        "authors": [strip_braces(a) for a in authors],
        "hauke_flags": is_hauke,
        "year": strip_braces(e.get("year", "")),
        "month": month,
        "title": strip_braces(e.get("title", "")),
        "venue": strip_braces(venue),
        "abbr": strip_braces(e.get("abbr", "")),
        "note": strip_braces(e.get("note", "")),
        "type": e.get("ENTRYTYPE", ""),
        "selected": (e.get("selected", "").lower() == "true"),
    }


def main() -> None:
    with open(BIB) as f:
        db = bibtexparser.load(f)
    entries = [parse_entry(e) for e in db.entries]
    entries.sort(key=lambda e: (e["year"] or "0", e["month"] or ""), reverse=True)
    OUT.parent.mkdir(exist_ok=True)
    with open(OUT, "w") as f:
        json.dump(entries, f, indent=2, ensure_ascii=False)
    print(f"Wrote {len(entries)} entries → {OUT.relative_to(REPO)}")


if __name__ == "__main__":
    main()
