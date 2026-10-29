---
layout: page
permalink: /publications/
title: publications
description: "Grouped by type, newest first within each group. Also see my <a href='https://scholar.google.com/citations?user=fZzd8BMAAAAJ&hl=en&oi=ao' target='_blank'>scholar profile</a>."
nav: true
nav_order: 2
---

<!-- _pages/publications.md
     Sections are driven by the `pubtype` field in _bibliography/papers.bib
     (journal | conference | short | workshop | organized | other).
     The under-review list comes from assets/json/resume.json. -->

{% include bib_search.liquid %}

<div class="publications">

{% assign ur = site.data.resume["under-review"] %}
{% if ur and ur.size > 0 %}

<h2 class="pubtype" id="under-review">Under review <span>{{ ur.size }}</span></h2>
<ul class="under-review">
{% for u in ur %}
  <li>
    <span class="title">{{ u.name }}</span><br />
    {% if u.summary %}{{ u.summary }}{% else %}{{ u.authors | join: ", " }}{% endif %} · <span class="venue">{{ u.publisher }}</span>
  </li>
{% endfor %}
</ul>
{% endif %}

<h2 class="pubtype" id="journal">Journal articles <span>peer-reviewed</span></h2>
{% bibliography --group_by none --query @*[pubtype=journal]* %}

<h2 class="pubtype" id="conference">Conference papers <span>full papers, peer-reviewed</span></h2>
{% bibliography --group_by none --query @*[pubtype=conference]* %}

<h2 class="pubtype" id="short">Short papers, posters &amp; late-breaking work <span>peer-reviewed</span></h2>
{% bibliography --group_by none --query @*[pubtype=short]* %}

<h2 class="pubtype" id="workshop">Workshop papers</h2>
{% bibliography --group_by none --query @*[pubtype=workshop]* %}

<h2 class="pubtype" id="organized">Workshops organized <span>as co-organizer</span></h2>
{% bibliography --group_by none --query @*[pubtype=organized]* %}

<h2 class="pubtype" id="other">Other <span>thesis, non-archival</span></h2>
{% bibliography --group_by none --query @*[pubtype=other]* %}

</div>
