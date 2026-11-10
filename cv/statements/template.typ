// Statement PDF template. bin/build-statements appends the pandoc-converted
// body of one _statements/*.md file to this header and compiles the result.
// Inputs: --input title="Research Statement" --input updated="November 2026"

#let resume = json("../../assets/json/resume.json")
#let accent = rgb("#f2511b")
#let muted  = luma(115)
#let rule   = luma(200)
#let title   = sys.inputs.at("title", default: "Statement")
#let updated = sys.inputs.at("updated", default: "")

#set page(
  paper: "us-letter",
  margin: (x: 0.95in, top: 0.8in, bottom: 0.8in),
  footer: context {
    set text(size: 7.5pt, fill: muted)
    grid(columns: (1fr, auto), [Hauke Sandhaus · #title], [#counter(page).display("1 of 1", both: true)])
  },
)
#set text(font: ("Helvetica Neue", "Helvetica", "Arial"), size: 10pt, lang: "en")
#set par(justify: false, leading: 0.62em, spacing: 0.75em)
#show link: set text(fill: accent)
#show heading.where(level: 3): it => block(above: 1.3em, below: 0.55em, text(size: 10.5pt, weight: "bold", it.body))
#show heading.where(level: 2): it => block(above: 1.3em, below: 0.55em, text(size: 11pt, weight: "bold", it.body))
#set enum(indent: 0.4em, body-indent: 0.5em, spacing: 0.6em)
#set list(indent: 0.4em, body-indent: 0.5em, spacing: 0.6em)

#grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
  [
    #text(size: 20pt, weight: "bold", tracking: -0.02em)[Hauke Sandhaus]
    #v(-0.35em)
    #text(size: 12pt, fill: accent)[#title]
  ],
  text(size: 8.5pt, fill: muted)[
    Ph.D. candidate in Information Science, Cornell Tech \
    #resume.basics.email · #link(resume.basics.url)[hauke.haus] \
    #if updated != "" [Generic version, #updated]
  ],
)
#v(0.3em)
#line(length: 100%, stroke: 0.5pt + rule)
#v(0.8em)

// ---- body (appended by bin/build-statements) ----
