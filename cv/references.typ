// Hauke Sandhaus — standalone references sheet (private: carries phone numbers).
// Public fields come from assets/json/resume.json (`references`); phone numbers,
// private emails and notes come from cv/private/references.json, which is
// gitignored. Build with `bin/build-references`, optionally
//   -o "Nissenbaum,Ju,Gray"   only these references, in resume.json order
//   -t "References for ..."   page title
//   -f path.pdf               output file (default cv/private/References_Sandhaus.pdf)

#let resume  = json("../assets/json/resume.json")
#let private = json("private/references.json")

#let accent = rgb("#f2511b")
#let muted  = luma(115)
#let rule   = luma(200)

#let only  = sys.inputs.at("only", default: "").split(",").map(s => s.trim()).filter(s => s != "")
#let title = sys.inputs.at("title", default: "References")

#set page(
  paper: "us-letter",
  margin: (x: 0.75in, top: 0.6in, bottom: 0.6in),
  footer: context {
    set text(size: 7.5pt, fill: muted)
    grid(columns: (1fr, auto),
      [Hauke Sandhaus · #title · not for publication],
      [#counter(page).display("1 of 1", both: true)])
  },
)
#set text(font: ("Helvetica Neue", "Helvetica", "Arial"), size: 9.5pt, lang: "en")
#set par(justify: false, leading: 0.55em, spacing: 0.6em)
#show link: set text(fill: accent)

#let clean(s) = s.replace(regex("<span[^>]*>.*?</span>"), "").replace(regex("<[^>]+>"), "").trim()
#let host(url) = url.replace(regex("^https?://(www\\.)?"), "").trim("/")

// Selection: all references, or those whose name contains one of the -o terms.
#let refs = resume.references.filter(r =>
  only.len() == 0 or only.any(o => lower(r.name).contains(lower(o))))

// ---------------------------------------------------------------- header
#grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
  [
    #text(size: 22pt, weight: "bold", tracking: -0.02em)[Hauke Sandhaus]
    #v(-0.3em)
    #text(size: 12pt, fill: accent)[#title]
  ],
  text(size: 8.5pt, fill: muted)[
    Ph.D. candidate in Information Science, Cornell Tech \
    #resume.basics.email · #link(resume.basics.url)[hauke.haus]
  ],
)
#v(0.3em)
#line(length: 100%, stroke: 0.5pt + rule)
#v(0.5em)
#text(size: 9pt, fill: muted)[
  All #refs.len() people listed here have agreed to write a letter. Their contact details are provided for this application only.
]
#v(0.8em)

// ---------------------------------------------------------------- entries
#let entry(i, r) = {
  let priv = private.at(r.name, default: (:))
  let email = priv.at("email", default: r.at("email", default: ""))
  let phone = priv.at("phone", default: "")
  let note  = priv.at("note", default: "")
  let url   = r.at("url", default: "")
  let who   = (r.at("title", default: ""), r.at("affiliation", default: "")).filter(x => x != "").join(", ")
  let about = clean(r.at("context", default: r.at("relationship", default: "")))

  let rows = ()
  if email != "" { rows.push(("Email", link("mailto:" + email)[#email])) }
  if phone != "" { rows.push(("Phone", phone)) }
  if url != ""   { rows.push(("Web", link(url)[#host(url)])) }
  if note != ""  { rows.push(("Note", note)) }

  block(breakable: false, width: 100%, above: 0.9em, below: 0.9em)[
    #grid(columns: (1.4em, 1fr), column-gutter: 0.4em,
      text(size: 9pt, fill: muted)[#i.],
      [
        #text(size: 11pt, weight: "bold")[#r.name]
        #h(0.5em) #text(size: 8.5pt, fill: muted)[#who] \
        #v(0.15em)
        #text(size: 9pt)[#about]
        #v(0.35em)
        #grid(columns: (3.2em, 1fr), column-gutter: 0.6em, row-gutter: 0.25em,
          ..rows.map(p => (text(size: 8pt, fill: muted)[#p.at(0)], text(size: 9pt)[#p.at(1)])).flatten())
      ],
    )
    #v(0.5em)
    #line(length: 100%, stroke: 0.4pt + luma(225))
  ]
}
#for (i, r) in refs.enumerate() { entry(i + 1, r) }
