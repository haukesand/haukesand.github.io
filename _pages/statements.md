---
layout: page
permalink: /statements/
title: statements
description: Research, teaching, and mentoring statements in their generic form, without the fit sections written for individual schools. Each is also available as a PDF.
nav: false
toc:
  sidebar: left
---

<!-- _pages/statements.md: content comes from _statements/*.md; PDFs are built by bin/build-statements -->

{% assign statements = site.statements | sort: "order" %}

<ul class="statement-index">
{% for s in statements %}
  <li><a href="#{{ s.title | slugify }}">{{ s.title }}</a> · <a href="{{ '/assets/pdf/' | append: s.pdf | relative_url }}" target="_blank" rel="noopener">PDF</a><br><span class="statement-summary">{{ s.summary }}</span></li>
{% endfor %}
</ul>

{% for s in statements %}

<h2 id="{{ s.title | slugify }}" class="statement-title">{{ s.title }}</h2>
<p class="statement-meta">Generic version, updated {{ s.updated | date: "%B %Y" }}. <a class="statement-pdf" href="{{ '/assets/pdf/' | append: s.pdf | relative_url }}" target="_blank" rel="noopener">Download PDF</a></p>

<div class="statement-body">
{{ s.content | markdownify }}
</div>

{% endfor %}
