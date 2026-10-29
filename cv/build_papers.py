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


def tidy(s: str) -> str:
    """Braces out, TeX quotes to typographic quotes, HTML tags out."""
    s = strip_braces(s)
    s = s.replace("``", "\u201c").replace("''", "\u201d")
    s = re.sub(r"<span[^>]*aria-hidden[^>]*>.*?</span>", "", s, flags=re.S)
    s = re.sub(r"<[^>]+>", "", s)
    return re.sub(r"\s+", " ", s).strip()


MONTH_NUM = {m: i for i, m in enumerate(
    ["jan", "feb", "mar", "apr", "may", "jun",
     "jul", "aug", "sep", "oct", "nov", "dec"], 1)}


def parse_entry(e: dict) -> dict:
    authors_raw = e.get("author", "")
    authors = [flip_name(a) for a in re.split(r"\s+and\s+", authors_raw)]
    is_hauke = [
        "hauke" in a.lower() and "sandhaus" in a.lower() for a in authors
    ]
    venue = (e.get("booktitle") or e.get("journal") or e.get("school")
             or e.get("howpublished") or "")
    note = tidy(e.get("note", ""))
    if tidy(venue) == note:  # e.g. thesis entries repeat the note in howpublished
        note = ""
    raw_month = (e.get("month") or "").lower()[:3]
    month = MONTHS.get(raw_month, e.get("month", ""))
    return {
        "key": e.get("ID", ""),
        "authors": [strip_braces(a) for a in authors],
        "hauke_flags": is_hauke,
        "year": strip_braces(e.get("year", "")),
        "month": month,
        # no month (e.g. "accepted, forthcoming") sorts to the top of its year
        "month_num": MONTH_NUM.get(raw_month, 13),
        "title": tidy(e.get("title", "")),
        "venue": tidy(venue),
        "abbr": strip_braces(e.get("abbr", "")),
        "note": note,
        "award": tidy(e.get("award", "")),
        "pubtype": strip_braces(e.get("pubtype", "other")),
        "type": e.get("ENTRYTYPE", ""),
        "selected": (e.get("selected", "").lower() == "true"),
    }


def initials(full: str) -> str:
    """'Doris Maria Rhomberg' -> 'Rhomberg, D. M.' (keeps a trailing * marker)."""
    parts = full.split()
    if len(parts) == 1:
        return parts[0]
    last_idx = len(parts) - 1
    while last_idx > 0 and parts[last_idx - 1].lower() in ("von", "van", "de", "di", "da"):
        last_idx -= 1
    last = " ".join(parts[last_idx:])
    return last + ", " + " ".join(f"{f[0]}." for f in parts[:last_idx] if f)


def sync_resume_publications(entries: list) -> None:
    """Mirror the bib into resume.json's `publications` (used by the /cv/ web page)."""
    path = REPO / "assets" / "json" / "resume.json"
    text = path.read_text()
    pubs = []
    for e in entries:
        date = e["year"] + (f"-{e['month_num']:02d}" if e["month_num"] <= 12 else "")
        equal = "equal" in e["note"]
        pubs.append({
            "name": e["title"],
            "publisher": e["venue"]
            + (f" ({e['note']})" if e["note"] and not equal else "")
            + (f" ({e['award']})" if e["award"] else ""),
            "releaseDate": date,
            "summary": ", ".join(initials(a) for a in e["authors"])
            + (f" ({e['note']})" if equal else ""),
        })
    block = json.dumps(pubs, indent=2, ensure_ascii=False)
    block = "\n".join(("  " + ln) if ln.strip() else ln for ln in block.splitlines())[2:]
    start = text.index('"publications": ')
    end = text.index('  "skills": [')
    text = text[:start] + '"publications": ' + block + ",\n" + text[end:]
    json.loads(text)
    path.write_text(text)
    print(f"Synced {len(pubs)} entries → assets/json/resume.json [publications]")


def main() -> None:
    with open(BIB) as f:
        db = bibtexparser.load(f)
    entries = [parse_entry(e) for e in db.entries]
    entries.sort(key=lambda e: (int(e["year"] or 0), e["month_num"]), reverse=True)
    OUT.parent.mkdir(exist_ok=True)
    with open(OUT, "w") as f:
        json.dump(entries, f, indent=2, ensure_ascii=False)
    print(f"Wrote {len(entries)} entries → {OUT.relative_to(REPO)}")
    sync_resume_publications(entries)


if __name__ == "__main__":
    main()
