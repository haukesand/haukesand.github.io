// Hauke Sandhaus — CV
// Two-column academic CV mirroring the Google Docs layout.
// Data lives in assets/json/resume.json (single source of truth with the
// site) and cv/papers.json (built from _bibliography/papers.bib via
// cv/build_papers.py). Compile with `./bin/build-cv`.

#let resume = json("../assets/json/resume.json")
#let papers = json("papers.json")

#let accent = rgb("#f2511b")
#let muted  = luma(115)
#let rule   = luma(200)

#set page(
  paper: "us-letter",
  margin: (x: 0.55in, top: 0.5in, bottom: 0.55in),
)

#set text(
  font: ("Helvetica Neue", "Inter", "Helvetica", "Arial"),
  size: 9pt,
  fill: black,
  lang: "en",
)
#set par(justify: false, leading: 0.5em, spacing: 0.55em)

#let SIDEBAR = 26%
#let GUTTER = 1em

// Section label (left column) — small caps, tracked, orange bar above
#let label(name) = align(right, box(width: 100%)[
  #line(length: 22pt, stroke: 1.5pt + accent)
  #v(-0.25em)
  #text(size: 9pt, weight: "bold", tracking: 0.05em)[#upper(name)]
])

// Two-column row
#let section(name, body) = {
  grid(
    columns: (SIDEBAR, 1fr),
    gutter: GUTTER,
    label(name),
    body,
  )
  v(0.9em)
}

// One work / education entry: header line + metadata + body
#let entry(header, meta, body) = block(spacing: 0.55em)[
  #text(weight: "regular")[#header] \
  #text(size: 7.5pt, tracking: 0.06em, fill: muted)[#upper(meta)]
  #v(-0.2em)
  #body
]

#let bullets(items) = if items != none and items.len() > 0 [
  #for it in items [
    - #it
  ]
]

// Author list rendering — bolds Hauke
#let render-authors(p) = {
  let n = p.authors.len()
  let out = []
  for i in range(n) {
    let name = p.authors.at(i)
    let is-hauke = p.hauke_flags.at(i)
    out += if is-hauke { strong(name) } else { text(name) }
    if i < n - 1 { out += text(", ") }
  }
  out
}

// ISO date "2018-10" → "October 2018". Plain year passes through.
#let months = (
  "01": "January", "02": "February", "03": "March", "04": "April",
  "05": "May", "06": "June", "07": "July", "08": "August",
  "09": "September", "10": "October", "11": "November", "12": "December",
)
#let format-date(d) = {
  if d == none or d == "" { return "" }
  let parts = d.split("-")
  if parts.len() >= 2 and months.at(parts.at(1), default: "") != "" {
    months.at(parts.at(1)) + " " + parts.at(0)
  } else {
    d
  }
}
#let format-range(start, endv) = {
  let s = format-date(start)
  let e = if endv == "" or endv == none { "Present" } else { format-date(endv) }
  if s == e { s } else { s + " – " + e }
}

// ============================================================================
// HEADER
// ============================================================================
#grid(
  columns: (SIDEBAR, 1fr),
  gutter: GUTTER,
  align(right)[
    #text(size: 24pt, weight: "bold", tracking: -0.02em)[Hauke\ Sandhaus]
    #v(-0.2em)
    #text(size: 8pt, fill: muted, tracking: 0.1em)[HCI RESEARCHER \ & UX TECHNOLOGIST]
  ],
  [
    #v(0.5em)
    #text(size: 8.5pt)[
      #text(fill: muted)[Cornell Tech · 2 West Loop Road · New York, NY 10044] \
      #resume.basics.email · #link(resume.basics.url)[hauke.haus]
    ]
    #v(0.4em)
    #text(size: 8.5pt, style: "italic", fill: muted)[
      Designing AI interfaces that actively facilitate — not merely respect — user autonomy, bridging Nissenbaum's contextual integrity framework with commercial-scale AI deployment.
    ]
  ]
)

#v(0.6em)
#line(length: 100%, stroke: 0.5pt + rule)
#v(0.4em)

// ============================================================================
// CURRENTLY (== work[0])
// ============================================================================
#let cur = resume.work.at(0)
#let now = resume.work.at(1) // GRA is at 0 after our recent insert — safer to detect

// Prefer the Ph.D. Candidate entry as "Currently"
#let phd = resume.work.find(w => w.position.contains("Ph.D."))
#section("Currently", entry(
  [*#phd.name* / #phd.position],
  [Started August 2021 · Expected graduation July 2027 · NYC, NY, USA],
  [
    Advised by Helen Nissenbaum (Chair), Wendy Ju (Co-Chair), and Qian Yang (Committee Member).

    #text(fill: accent)[*Research:*] Designing AI interfaces that actively facilitate — not merely respect — user autonomy, bridging Nissenbaum's contextual integrity framework with commercial-scale AI deployment.
  ]
))

// ============================================================================
// PROFESSIONAL EXPERIENCE (skip the PhD row we already rendered)
// ============================================================================
#let work-body = {
  for w in resume.work {
    if w == phd { continue }
    entry(
      [*#w.name* / #w.position],
      [#format-range(w.startDate, w.endDate)],
      [
        #w.summary
        #bullets(w.highlights)
      ]
    )
  }
}
#section("Professional Experience", work-body)

// ============================================================================
// EDUCATION
// ============================================================================
#let edu-body = {
  for ed in resume.education {
    entry(
      [*#ed.institution* / #ed.studyType],
      [#ed.startDate – #ed.endDate],
      {
        if ed.at("area", default: "") != "" { emph(ed.area); linebreak() }
        if ed.at("score", default: "") != "" { text(ed.score); linebreak() }
        bullets(ed.at("highlights", default: ()))
      }
    )
  }
}
#section("Education", edu-body)

// ============================================================================
// SERVICE & TEACHING (volunteer)
// ============================================================================
#let vol-body = {
  for v in resume.volunteer {
    entry(
      [*#v.position* — #v.organization],
      [#v.startDate #if v.endDate != v.startDate [– #v.endDate] #if v.location != "" [ · #v.location]],
      [#v.summary]
    )
  }
}
#section("Service & Teaching", vol-body)

// ============================================================================
// FELLOWSHIPS & AWARDS
// ============================================================================
#let awards-body = {
  for a in resume.awards {
    entry(
      [*#a.title*],
      [#format-date(a.date) · #a.awarder],
      [#a.summary]
    )
  }
}
#section("Fellowships & Awards", awards-body)

// ============================================================================
// PUBLICATIONS
// ============================================================================
#let pub-item(p) = {
  let date-part = if p.month != "" and p.year != "" {
    p.month + " " + p.year
  } else if p.year != "" {
    p.year
  } else { "" }
  let venue-part = if p.venue != "" { emph(p.venue) } else { text("") }
  let note-part = if p.note != "" [ · #emph(p.note)]
  [#render-authors(p) (#date-part). #p.title. #venue-part.#note-part]
}

#let pubs-body = {
  set list(indent: 0.4em, body-indent: 0.35em)
  for p in papers [
    - #pub-item(p)
  ]
}
#section("Publications", pubs-body)

// ============================================================================
// SKILLS
// ============================================================================
#let skills-body = {
  set par(leading: 0.5em)
  for s in resume.skills [
    *#s.name:* #s.keywords.join(", ") \
  ]
}
#section("Skills", skills-body)
