---
layout: page
title: projects
permalink: /projects/
description: Websites, tools, and experiments that came out of the research. Each tile opens a short write-up with links. Status tells you whether I still maintain it.
nav: true
nav_order: 3
---

<!-- _pages/projects.md: tiles come from _projects/*.md via _includes/project_tile.liquid -->

{% assign tools = site.projects | where: "category", "tools" | sort: "importance" %}
{% assign experiments = site.projects | where: "category", "experiments" | sort: "importance" %}
{% assign archive = site.projects | where: "category", "archive" | sort: "importance" %}

<h2 class="project-section">Research tools &amp; sites</h2>
<div class="project-grid">
{% for project in tools %}{% include project_tile.liquid %}{% endfor %}
</div>

<h2 class="project-section">Experiments &amp; installations</h2>
<div class="project-grid">
{% for project in experiments %}{% include project_tile.liquid %}{% endfor %}
</div>

<h2 class="project-section">Archive</h2>
<div class="project-grid">
{% for project in archive %}{% include project_tile.liquid %}{% endfor %}
</div>
