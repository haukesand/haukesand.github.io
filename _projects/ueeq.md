---
layout: page
title: UEEQ
description: A five-scale addendum to the UEQ that measures whether users experience a design as deceptive, addictive, coercive, disguised, or annoying.
img: assets/img/projects/ueeq.png
years: 2024 – now
status: maintaining
with: Doris Maria Rhomberg
category: tools
importance: 2
related_publications: true
---

<img class="project-hero" src="{{ '/assets/img/projects/ueeq.png' | relative_url }}" alt="ueeq.org, the User Experienced Ethics Questionnaire" />

<div class="project-facts">
  <div><span class="k">Status</span>maintaining; analysis tools in development</div>
  <div><span class="k">With</span>Doris Maria Rhomberg (TU Wien)</div>
  <div><span class="k">Languages</span>English, German</div>
</div>

<div class="project-links">
  <a href="https://ueeq.org/" target="_blank" rel="noopener">Website</a>
  <a href="https://www.ueq-online.org/" target="_blank" rel="noopener">UEQ (the base questionnaire)</a>
</div>

Standard UX questionnaires measure whether a product is pragmatic and hedonic. They say nothing about whether it is honest. Doris Maria Rhomberg and I built the User Experienced Ethics Questionnaire (UEEQ) to close that gap. It is an addendum to the short User Experience Questionnaire (UEQ-S) with five extra scales: Deception, Addictiveness, Coercion, Disguise, and Annoyance. Items are bipolar adjective pairs, for example benevolent versus deceptive and suggesting versus pressuring, presented in randomized order and direction.

The scales came out of a survey in which 126 social media users rated mockups of fifteen dark patterns {% cite rhomberg_towards_2024 %}. Perceived deception tracked negative aesthetic judgment closely, which is the finding behind the journal article {% cite Sandhaus2026-deception %}. A follow-up experiment with 141 UX professionals showed that putting these items on an evaluation dashboard nearly doubled the rate at which designers rejected manipulative interfaces {% cite Sandhaus2026-indecent %}.

ueeq.org hosts the questionnaire in English and German, the citation we ask for, and a link to the OSF repository with the dark pattern mockups. Scoring and analysis tools are still in development, so for now UEEQ is a research instrument rather than a finished product.
