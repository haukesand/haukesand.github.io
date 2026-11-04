// Hauke Sandhaus — Portfolio of creative work
// Landscape companion to cv/cv.typ. Images live in cv/portfolio/, contact
// data comes from assets/json/resume.json. Build with `./bin/build-portfolio`.

#let resume = json("../assets/json/resume.json")
#let accent = rgb("#f2511b")
#let muted  = luma(110)
#let rule   = luma(205)
#let IMG    = "portfolio/"

#set page(
  paper: "us-letter",
  flipped: true,
  margin: (x: 0.6in, top: 0.5in, bottom: 0.5in),
  footer: context {
    let n = counter(page).get().first()
    if n > 1 {
      set text(size: 7.5pt, fill: muted)
      grid(columns: (1fr, auto), [Hauke Sandhaus · Portfolio of creative work · hauke.haus], [#n])
    }
  },
)
#set text(font: ("Helvetica Neue", "Helvetica", "Arial"), size: 9.5pt, fill: black, lang: "en")
#set par(justify: false, leading: 0.55em, spacing: 0.7em)
#show link: set text(fill: accent)

// ---------------------------------------------------------------- helpers
#let kicker(s) = text(size: 7.5pt, weight: "bold", tracking: 0.09em, fill: accent)[#upper(s)]
#let meta(s) = text(size: 8pt, fill: muted)[#s]
#let cap(s) = text(size: 7.5pt, fill: muted)[#s]

// Clipped image of a fixed height, optional caption underneath.
#let fig(path, height: 2in, caption: none, fit: "cover") = block(spacing: 0pt, width: 100%)[
  #box(width: 100%, height: height, clip: true, radius: 2pt, fill: luma(243))[
    #image(IMG + path, width: 100%, height: 100%, fit: fit)
  ]
  #if caption != none [ #v(0.3em) #cap(caption) ]
]

#let facts(..pairs) = {
  set text(size: 8pt)
  let cells = ()
  for p in pairs.pos() { cells.push(text(fill: muted)[#p.at(0)]); cells.push(p.at(1)) }
  grid(columns: (auto, 1fr), column-gutter: 0.8em, row-gutter: 0.35em, ..cells)
}

#let links(..items) = {
  set text(size: 8pt)
  items.pos().map(i => link(i.at(1))[#i.at(0)]).join(text(fill: muted)[  ·  ])
}

#let page-head(title, years, kick) = {
  kicker(kick)
  v(-0.2em)
  grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
    text(size: 22pt, weight: "bold")[#title],
    meta(years),
  )
  v(-0.1em)
  line(length: 100%, stroke: 0.6pt + rule)
  v(0.7em)
}

// Two-column project page: images left, text right.
#let project(title, years, kick, images, body) = {
  page-head(title, years, kick)
  grid(columns: (61%, 1fr), column-gutter: 0.42in, images, body)
}

// Card for the grid pages.
#let tile(img, title, years, body, url: none, height: 1.75in, size: 8.5pt) = block(spacing: 0pt, width: 100%)[
  #fig(img, height: height)
  #v(0.55em)
  #text(weight: "bold")[#title] #h(0.5em) #meta(years)

  #text(size: size, body)

  #if url != none [ #text(size: 8pt, link(url, url.replace(regex("^https?://"), "").trim("/"))) ]
]

#let pageref(name) = context { counter(page).at(label(name)).first() }

// ================================================================= COVER
#grid(columns: (44%, 1fr), column-gutter: 0.5in,
  [
    #v(1.1in)
    #text(size: 40pt, weight: "bold", tracking: -0.01em)[Hauke \ Sandhaus]
    #v(0.4em)
    #text(size: 17pt, fill: accent)[Portfolio of creative work]
    #v(1.4em)
    #text(size: 10.5pt)[Installations, physical prototypes, and public tools for honest design. 2015 to 2026.]
    #v(2.2in)
    #meta[hauke.haus · #resume.basics.email · November 2026]
  ],
  grid(columns: (1fr, 1fr), gutter: 0.12in,
    fig("commodity-printer.jpg", height: 2.36in),
    fig("wizardcab-arrived.jpg", height: 2.36in),
    fig("sonification-front.jpg", height: 2.36in),
    fig("vw-pod.jpg", height: 2.36in),
    fig("showcase-hall.jpg", height: 2.36in),
    fig("commodity-art.jpg", height: 2.36in),
  ),
)

#pagebreak()
// ================================================================= ABOUT + CONTENTS
#metadata(none) <p-about>
#grid(columns: (40%, 1fr), column-gutter: 0.5in,
  [
    #kicker("About this portfolio")
    #v(0.4em)
    #text(size: 10.5pt)[
      I make things that take a position. A fake autonomous car that calms its passengers with a light bar. A receipt printer that sells AI-made apps for a quarter. A questionnaire that asks users whether a design was honest with them.

      I trained as a creative technologist at the University of Twente, did a master's in human-computer interaction at the Bauhaus-Universität Weimar, and spent three years prototyping the user experience of autonomous vehicles at the Volkswagen Group Future Center. I am now finishing a Ph.D. at Cornell Tech on how interfaces respect or undermine people's autonomy, advised by Helen Nissenbaum and Wendy Ju.

      Most of the recent work is public and in use: websites, repositories, templates, a curriculum. The older work lives in photographs and renders. Links point to the live pieces where they exist.
    ]
    #v(1.2em)
    #facts(
      ("Projects", link("https://hauke.haus/projects/")[hauke.haus/projects]),
      ("Archive 2014–2021", link("https://hauke.haus/sandhaus.de/")[hauke.haus/sandhaus.de]),
      ("Code", link("https://github.com/HaukeCornell")[github.com/HaukeCornell]),
      ("Papers", link("https://scholar.google.com/citations?user=fZzd8BMAAAAJ")[Google Scholar]),
    )
  ],
  [
    #kicker("Contents")
    #v(0.4em)
    #let row(img, title, years, name) = (
      fig(img, height: 0.52in),
      [#text(weight: "bold")[#title] \ #meta(years)],
      align(right + horizon, text(size: 9pt, fill: muted)[#pageref(name)]),
    )
    #grid(columns: (0.85in, 1fr, auto), column-gutter: 0.7em, row-gutter: 0.5em, align: (left, left + horizon, right + horizon),
      ..row("commodity-printer.jpg", "App Design as a Commodity", "Installation, 2025", "p-commodity"),
      ..row("wizardcab-arrived.jpg", "Wizard Cab", "Fake autonomous vehicle and ambient display, 2017–2018", "p-wizardcab"),
      ..row("sonification-front.jpg", "Sonification", "A costume that turns dance into sound, 2017–2018", "p-sonification"),
      ..row("filli-render.jpg", "Filli and Luft-Raum-Volumen", "Objects and renderings, 2016", "p-objects"),
      ..row("showcase-hall.jpg", "Gestures, games, and parallel realities", "Student prototypes, 2015–2016", "p-student"),
      ..row("elixier-workbench.jpg", "Augmented workbenches and voice", "ELIXIER and Searchbullet, 2016–2018", "p-elixier"),
      ..row("vw-pod.jpg", "Volkswagen Group Future Center", "Concept prototypes, 2018–2021", "p-vw"),
      ..row("ueeq.png", "Tools for honest design", "Bright Patterns, UEEQ, Autonomy Rubric, 2023–2026", "p-tools"),
      ..row("vibecoding.png", "Teaching and public-interest design", "Canvas, workshop, course, repository, 2024–2026", "p-teaching"),
    )
  ],
)

#pagebreak()
// ================================================================= APP DESIGN AS A COMMODITY
#metadata(none) <p-commodity>
#project("App Design as a Commodity", "2025", "Installation · Backslash, Cornell Tech",
  grid(columns: (1.08fr, 1fr), column-gutter: 0.12in, row-gutter: 0.12in,
    grid.cell(rowspan: 2, fig("commodity-printer.jpg", height: 5.75in, caption: "The receipt printer hands over the app. Still from the documentation video.")),
    fig("commodity-receipt-hand.jpg", height: 3.1in, caption: "The receipt: order, payment, the link to the hosted app, and the repository with its source."),
    fig("commodity-art.jpg", height: 2.2in, caption: "One of the purchased apps: an AI art installation, bought for $0.25."),
  ),
)[
  A thermal receipt printer sits on a table next to a Venmo QR code. You scan it, send 25 cents or a dollar, and write in the payment note what app you want. A few minutes later the printer hums and hands you a receipt with a QR code. Behind it is your app: generated, pushed to a public GitHub repository, and hosted on the web.

  The amount you pay sets the budget. A quarter buys a quick build, a dollar a stronger model and more effort. A Flask backend watches the Venmo confirmation emails, hands the description to a coding agent, deploys the result, and prints the receipt with the transaction details, the link, and the build log.

  The piece asks what you are buying when software costs less than a coffee and takes less time to make than drinking one. The receipt is the only physical trace of a process that is otherwise invisible.

  #v(0.6em)
  #facts(
    ("Shown", "May 6, 2025, Cornell Tech"),
    ("Funding", "Backslash art and technology microgrant"),
    ("Stack", "Thermal printer, Venmo, Flask, Gemini, GitHub API"),
  )
  #v(0.6em)
  #links(
    ("Video (60 s)", "https://hauke.haus/projects/app-design-as-a-commodity/"),
    ("Code", "https://github.com/HaukeCornell/App-Design-as-a-Commodity"),
    ("All generated apps", "https://github.com/sandvibe?tab=repositories"),
  )
]

#pagebreak()
// ================================================================= WIZARD CAB
#metadata(none) <p-wizardcab>
#project("Wizard Cab", "2017–2018", "Fake autonomous vehicle · Master's thesis",
  [
    #fig("wizardcab-arrived.jpg", height: 3.45in, caption: "Arrived at destination, shown on the ambient light bar.")
    #v(0.12in)
    #grid(columns: (1fr, 1fr), column-gutter: 0.12in,
      fig("wizardcab-swerve.jpg", height: 2.0in, caption: "Swerve left, announced before the maneuver."),
      fig("wizardcab-bus.jpg", height: 2.0in, caption: "Accelerating hard. Renderings: Robert Bosch NA, 2018."),
    )
  ],
)[
  The Wizard Cab is a fake autonomous vehicle. One researcher drives, another operates the output, and the passengers believe the car is driving itself. I built it for my master's thesis to test an ambient light bar that tells passengers what the car is about to do: brake hard, swerve, turn left, arrived. The question was whether this kind of feedforward information calms people, and how much of it they want.

  The light bar is a quiet way to show driving decisions. It does not demand attention the way a screen does, and passengers can ignore it. Several signals were designed and animated, among them brake hard, swerve, turn left, and arrived at destination.

  The work was done during an internship at Robert Bosch Car Multimedia, where I also built vehicle-to-everything interfaces as HTML5 animations and researched interfaces for older adults and passengers with disabilities.

  #v(0.6em)
  #facts(
    ("Where", "Bauhaus-Universität Weimar with Eva Hornecker; Robert Bosch"),
    ("Paper", "A WOZ Study of Feedforward Information on an Ambient Display in Autonomous Cars. UIST '18 Adjunct"),
  )
  #v(0.6em)
  #links(("Light bar animations", "https://hauke.haus/sandhaus.de/"))
]

#pagebreak()
// ================================================================= SONIFICATION
#metadata(none) <p-sonification>
#project("Sonification", "2017–2018", "Interactive costume · with Aline Martinez",
  [
    #grid(columns: (1fr, 1fr, 1fr), column-gutter: 0.12in,
      fig("sonification-front.jpg", height: 3.9in),
      fig("sonification-back.jpg", height: 3.9in),
      fig("sonification-closeup.jpg", height: 3.9in),
    )
    #v(0.12in)
    #grid(columns: (1fr, 2fr), column-gutter: 0.12in,
      fig("sonification-sensors.jpg", height: 1.55in, fit: "contain", caption: "Six handwoven sensors at the joints, wireless to a sequencer."),
      [#v(0.2em) #cap[The costume on a ballet dancer: front, back, and detail. Each sensor is woven into the garment and sends its reading to the sequencer.]],
    )
  ],
)[
  Sonification is a costume for professional dancers that turns their movement into sound. Fashion designer Aline Martinez and I made it with ballet dancers from Altenburg. Six handwoven textile sensors sit at the joints and communicate wirelessly with a software sequencer, so the dancer plays the score while dancing it.

  The sensors are part of the garment rather than attached to it, which is what makes the costume wearable on stage. The costume itself and the findings from our research with the dancers were published alongside the D_TEX conference in Portugal.

  #v(0.6em)
  #facts(
    ("Where", "Bauhaus-Universität Weimar"),
    ("Paper", "Smart Textiles in the Performing Arts, with Aline Martinez, Michaela Honauer, and Eva Hornecker. Textiles, Identity and Innovation: Design the Future, 2018"),
  )
]

#pagebreak()
// ================================================================= OBJECTS
#metadata(none) <p-objects>
#project("Filli and Luft-Raum-Volumen", "2016", "Product design and renderings · Bauhaus-Universität Weimar",
  grid(columns: (1fr, 1fr, 1fr), gutter: 0.12in,
    fig("filli-object.jpg", height: 2.55in, caption: "Filli. The silicone sleeve, filled and hardened."),
    fig("filli-render.jpg", height: 2.55in, caption: "Product rendering with the grain fillings."),
    fig("filli-box.jpg", height: 2.55in, caption: "Packaging."),
    fig("luft-klappe.jpg", height: 2.55in, caption: "Luftregelklappe: a pneumatic ventilation appliance for living rooms."),
    fig("luft-zelle.jpg", height: 2.55in, caption: "Luftzelle: transport packaging for exporting fresh air to China."),
    fig("luft-bruecke.jpg", height: 2.55in, caption: "Luftbrücke: a landing platform for drone deliveries to high-rises."),
  ),
)[
  Luft-Raum-Volumen (air, space, volume) was a product design course at the Bauhaus-Universität Weimar.

  Filli, my main piece, is a sex toy whose shape, texture, and volume the user can change. A silicone sleeve is filled with grains of different sizes and hardened by negative pressure, the granular jamming principle also used in soft robotics. The project covered the object, its packaging, and the product photography and renderings.

  Three speculative renderings came out of the same course. Luftregelklappe, a light-giving, pneumatically driven ventilation appliance for living rooms. Luftzelle, transport packaging for the export of fresh breathing air to China. Luftbrücke, a landing platform for drone deliveries to high-rise buildings.

  #v(0.6em)
  #facts(
    ("Archive", link("https://hauke.haus/sandhaus.de/")[hauke.haus/sandhaus.de]),
  )
]

#pagebreak()
// ================================================================= STUDENT WORK
#metadata(none) <p-student>
#project("Gestures, games, and parallel realities", "2015–2016", "Student prototypes · University of Twente and Bauhaus-Universität Weimar",
  grid(columns: (1fr, 1fr, 1fr), gutter: 0.12in,
    fig("showcase-hall.jpg", height: 2.5in, caption: "Touchless showcases by 100%FAT in the DesignLab, University of Twente."),
    fig("showcase-screen.jpg", height: 2.5in, caption: "The showcase screen, controlled by hand gestures above a Leap Motion sensor."),
    fig("showcase-game.jpg", height: 2.5in, caption: "The study game: hover, push, squeeze, and aim as selection methods."),
    fig("showcase-test.jpg", height: 2.5in, caption: "Test setup for the gesture study."),
    fig("parallel-realities.jpg", height: 2.5in, caption: "Parallel Realities: a virtual cave mapped onto the real room."),
    fig("ama-phone.jpg", height: 2.5in, fit: "contain", caption: "Ask Me Anonymously, an icebreaker over Wi-Fi Direct."),
  ),
)[
  *Touchless showcase.* Bachelor thesis in Creative Technology, 2015. 100%FAT builds glass showcases that visitors control with a Leap Motion sensor. I gave them a 3D gesture interface on a flat vertical screen. Users struggled to build a mental model of that displaced space, so I ran a study with a game that compared selection methods before building the final prototype. It was installed permanently in the DesignLab and received the Thesis of the Year award at the University of Twente.

  *Parallel Realities.* A mix of augmented and virtual reality: the whole environment is rendered, but the virtual objects stay in relation to the real room. Built with Unity and Vuforia; players track their surroundings with a phone and explore a virtual cave.

  *Ask Me Anonymously.* An Android icebreaker game over Wi-Fi Direct, with no router in between. Players vote on uncomfortable questions and one randomly chosen player answers in public. Players add their own questions and build their own database.

  #v(0.6em)
  #facts(("Archive", link("https://hauke.haus/sandhaus.de/projects-2016.html")[hauke.haus/sandhaus.de/projects-2016]))
]

#pagebreak()
// ================================================================= ELIXIER + SEARCHBULLET
#metadata(none) <p-elixier>
#project("Augmented workbenches and voice", "2016–2018", "Research prototypes · ELIXIER and Searchbullet",
  [
    #fig("elixier-workbench.jpg", height: 2.65in, caption: "ELIXIER: an augmented workbench for technical training.")
    #v(0.12in)
    #grid(columns: (1fr, 1.4fr), column-gutter: 0.12in,
      fig("elixier-board.jpg", height: 2.65in, caption: "ELIXIER chemistry experiment board."),
      fig("searchbullet.jpg", height: 2.65in, fit: "contain", caption: "Searchbullet: ask a Google Home, receive the results on the device you are holding."),
    )
  ],
)[
  *ELIXIER.* 2016–2017. A research project funded by the German Federal Ministry of Education and Research with several university and industry partners, on technically supported training environments. As a student researcher at the Bauhaus I evaluated the interfaces and the user experience of multimodal, augmented workbenches, ran user tests, and developed an augmented-reality manual for chemistry experiments, alongside more general research on augmented reality, projection, and tangible interfaces.

  *Searchbullet.* 2018. Search by voice on a Google Home and push the results to your other devices. Built with Jovo, Dialogflow, and Pushbullet. I also developed the voice interface for an Alexa skill of Netspeak.org, the phrase search engine from the Bauhaus.

  #v(0.6em)
  #facts(
    ("Role", "Student researcher, ELIXIER, August 2016 to April 2017"),
    ("Stack", "Jovo, Dialogflow, Pushbullet, Google Assistant, Alexa"),
  )
]

#pagebreak()
// ================================================================= VOLKSWAGEN
#metadata(none) <p-vw>
#page-head("Volkswagen Group Future Center", "2018–2021", "Industry · UX Technologist, Digital User Experience Design")
#text(size: 9.5pt)[From October 2018 to August 2021 I was a UX Technologist at the Volkswagen Group Future Center, the group's independent concept studio, under the vision "mobility for all, at the push of a button". I sat between the strategy, research, and software circles and turned concepts into tangible prototypes that could be tested with users. Everything here is concept work shown at a high level; the details remain unpublished.]
#v(0.4em)
#links(("Project page", "https://hauke.haus/projects/vw-future-center/"), ("2021 work portfolio", "https://hauke.haus/assets/pdf/Archive/Job_Portfolio_2021.pdf"))
#v(0.5em)
#grid(columns: (1fr, 1fr), column-gutter: 0.3in, row-gutter: 0.3in,
  tile("vw-pod.jpg", "Self-driving pods", "inclusive design, urban transformation", height: 1.75in)[
    The user experience of fully autonomous pods, which break with almost everything a car used to be. The relationship to passengers and to the street had to be rethought from the basics. The goal was better, more sustainable, and more accessible mobility for all. I built the tangible prototypes that verified the concepts with users and turned them into requirements.
  ],
  tile("vw-flying.jpg", "Flying cars", "drones, augmented reality, semi-manual flight", height: 1.75in)[
    A lightweight interface concept for an electric vertical take-off and landing vehicle of a German luxury brand, based on interviews with ultra-high-net-worth individuals. I did the needs analysis, built the hardware for controlling the vehicle, and developed augmented-reality interactions in a flight simulator.
  ],
  tile("vw-voice.jpg", "AI voice", "voice interaction, visual AI, privacy", height: 1.75in)[
    An empathic voice assistant for fully and semi-autonomous vehicles, developed with visually impaired and older adults. I trained the models and built the embedded voice recognition (Snips), prototypes with OpenPose, YOLO, and Runway for proactive use cases, and motorized camera shutters for in-cabin privacy. I also tested the voice feedback of autonomous vehicles with visually impaired passengers.
  ],
  tile("vw-driver-ui.jpg", "Digital driver UI", "front-end development, measuring UX, ideation", height: 1.75in)[
    Interfaces for connected cars with growing automation that make productivity and entertainment possible on the road. High-fidelity interactive prototypes, fully explorable, integrated with a driving simulator and meant for production. I did the ideation, the front-end software and hardware, and the qualitative and quantitative research.
  ],
)

#pagebreak()
// ================================================================= TOOLS
#metadata(none) <p-tools>
#page-head("Tools for honest design", "2023–2026", "Public research instruments · Cornell Tech")
#text(size: 9.5pt)[My Ph.D. work asks how designers can tell legitimate influence from manipulation, and what helps them push back. These three sites are the public, usable side of that work. Each is maintained and cited.]
#v(0.7em)
#grid(columns: (1fr, 1fr, 1fr), column-gutter: 0.25in,
  tile("brightpatterns.png", "Bright Patterns", "2023 to now", url: "https://brightpatterns.org/", height: 2.8in, size: 9pt)[
    Dark patterns have a name, a taxonomy, and regulators. Their opposite did not. In a CHI '23 workshop paper I proposed bright patterns, benevolent design solutions that put user goals and well-being first. brightpatterns.org is the public face of the term: a Hall of Fame of fourteen named patterns with real examples, discoveries in the wild, and a submission form so the collection grows through nominations.
  ],
  tile("ueeq.png", "UEEQ", "2024 to now, with Doris Maria Rhomberg", url: "https://ueeq.org/", height: 2.8in, size: 9pt)[
    Standard UX questionnaires measure whether a product is pragmatic and hedonic, not whether it is honest. The User Experienced Ethics Questionnaire adds five scales to the UEQ-S: deception, addictiveness, coercion, disguise, and annoyance. In an experiment with 141 UX professionals, putting these items on an evaluation dashboard nearly doubled the rate at which designers rejected manipulative interfaces. Best late-breaking work award, CHIWORK '26.
  ],
  tile("rubric.png", "Human–AI Autonomy Rubric", "2025 to now", url: "https://human-ai-autonomy-rubric.surge.sh/", height: 2.8in, size: 9pt)[
    Everyone agrees AI should respect user autonomy. Few can say what that means for a specific feature. The rubric, co-designed with eight philosophers of autonomy, thirteen designers of AI systems, and three regulators, rates a feature as undermining, appropriately limiting, respecting, or supporting autonomy on each criterion. Version 12 is live with an evaluate-and-act mode and worked examples. Paper under review at CHI '27.
  ],
)

#pagebreak()
// ================================================================= TEACHING
#metadata(none) <p-teaching>
#page-head("Teaching and public-interest design", "2024–2026", "Curricula, canvases, and an open repository · Cornell Tech")
#grid(columns: (1fr, 1fr), column-gutter: 0.3in, row-gutter: 0.28in,
  tile("privacy-canvas.png", "The Privacy Policy Analysis Canvas", "2024–2025, with Helen Nissenbaum", url: "https://www.figma.com/community/file/1475988331450512233/the-privacy-policy-analysis-canvas", height: 1.7in)[
    A FigJam canvas that gets pairs of students to take a privacy policy apart in one class period using contextual integrity: five information flows, nine practice dimensions, a trust rating before and after. 59 students analyzed 31 policies in Privacy in the Digital Age; translated into eight languages; poster at NYC Privacy Day 2025.
  ],
  tile("conscientious.png", "Conscientious Technology Design Workshop", "2025 to now, with Jae June Lee and Helen Nissenbaum", url: "https://conscientious.tech.cornell.edu/", height: 1.7in)[
    An eight-week summer workshop for Siegel PiTech PhD Impact Fellows embedded at New York City agencies and non-profits. I turned the Values at Play framework into whiteboard activities and short assignments that fellows apply to their own placement. Two cohorts so far; funded by Cornell Tech's Public Interest Responsible Technology Fund.
  ],
  tile("vibecoding.png", "Ethical Vibe Coding", "Summer 2026, with Jonathan Segal and Wendy Ju", url: "https://vibe-coding-ethics.tech.cornell.edu/", height: 1.7in)[
    TECHIE 1121, a three-week course for high school students with no programming background. Students build hosted web apps with AI coding tools from day one, probe which defaults and biases the tools produce when nobody specifies them, and build dark patterns on purpose in order to recognize them. The course site doubles as a reusable curriculum.
  ],
  tile("obfuscation.jpg", "Obfuscation.tech", "2026 to now, with Helen Nissenbaum", url: "https://obfuscation.tech.cornell.edu/", height: 1.7in)[
    An open repository of obfuscation strategies for people who are not security researchers, built on the premise that the communication channel cannot be trusted. Fonts that stay readable for humans but useless for scrapers, ways to keep workplace tools from measuring you. Every page has an edit link; contributions are welcome.
  ],
)

#pagebreak()
// ================================================================= CLOSING
#metadata(none) <p-links>
#grid(columns: (1fr, 2.2in), column-gutter: 0.5in,
  [
    #v(0.6in)
    #kicker("Where to look next")
    #v(0.5em)
    #text(size: 10.5pt)[Everything in this portfolio is documented online, and most of it is still running.]
    #v(1em)
    #set text(size: 9.5pt)
    #facts(
      ("Projects", link("https://hauke.haus/projects/")[hauke.haus/projects]),
      ("Archived portfolio, 2014–2021", link("https://hauke.haus/sandhaus.de/")[hauke.haus/sandhaus.de]),
      ("Video, App Design as a Commodity", link("https://hauke.haus/projects/app-design-as-a-commodity/")[hauke.haus/projects/app-design-as-a-commodity]),
      ("Code", link("https://github.com/HaukeCornell")[github.com/HaukeCornell]),
      ("Publications", link("https://hauke.haus/publications/")[hauke.haus/publications]),
      ("Curriculum vitae", link("https://hauke.haus/assets/pdf/CV_Sandhaus.pdf")[hauke.haus/assets/pdf/CV_Sandhaus.pdf]),
    )
    #v(1.4em)
    #text(size: 9.5pt)[Hauke Sandhaus \ Ph.D. candidate in Information Science, Cornell Tech \ #link("mailto:" + resume.basics.email)[#resume.basics.email] · #link("https://hauke.haus")[hauke.haus]]
  ],
  [
    #v(0.6in)
    #fig("portrait.jpg", height: 2.9in)
  ],
)
