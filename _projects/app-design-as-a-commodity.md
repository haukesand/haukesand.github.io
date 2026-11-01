---
layout: page
title: App Design as a Commodity
description: An installation that sells custom apps for Venmo change. A receipt printer takes your order, an AI agent builds and hosts the app, and the receipt carries the QR code.
img: assets/img/projects/app-design-commodity.png
years: 2025
status: finished
status_label: exhibited May 2025
category: experiments
importance: 2
---

<img class="project-hero" src="{{ '/assets/img/projects/app-design-commodity.png' | relative_url }}" alt="The Vibe Coder receipt: pay $0.25 for a quick app or $1.00 for a high quality app" />

<div class="project-facts">
  <div><span class="k">Status</span>finished; exhibited May 6, 2025</div>
  <div><span class="k">Funding</span>Backslash microgrant, Cornell Tech</div>
  <div><span class="k">Stack</span>thermal printer, Venmo, Flask, Gemini, GitHub API</div>
</div>

<div class="project-links">
  <a href="https://github.com/HaukeCornell/App-Design-as-a-Commodity" target="_blank" rel="noopener">Code</a>
  <a href="https://github.com/sandvibe?tab=repositories" target="_blank" rel="noopener">All generated apps</a>
  <a href="https://backslash.org/artists" target="_blank" rel="noopener">Backslash artists</a>
</div>

A thermal receipt printer sits on a table next to a Venmo QR code. You scan it, send 25 cents or a dollar, and write in the payment note what app you want. A few minutes later the printer hums and hands you a receipt with a QR code. Behind it is your app: generated, pushed to a GitHub repository, and hosted on the web.

The amount you pay sets the budget. A quarter buys a quick build; a dollar buys a stronger model and more effort. A Flask backend watches the Venmo confirmation emails, hands the description to a coding agent, deploys the result to a public GitHub account, and prints the receipt with the transaction details, the link, and the system log of the build. All generated apps stay public at github.com/sandvibe.

The piece asks what you are buying when software costs less than a coffee and takes less time to make than drinking one. The receipt is the only physical trace of a process that is otherwise invisible. The project received a Backslash microgrant from Cornell Tech's art and technology program and was shown on May 6, 2025.



<video class="project-hero" controls preload="metadata" src="{{ '/assets/video/app-design-as-a-commodity.mp4' | relative_url }}"></video>

