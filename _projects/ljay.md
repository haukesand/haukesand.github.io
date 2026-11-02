---
layout: page
title: Ljay
description: Live lyrics karaoke and VJ visuals for DJ sets. Reads macOS Now Playing, pulls synced lyrics, and renders audio-reactive scenes in the browser.
img: assets/img/projects/ljay.png
years: 2026 – now
status: started
status_label: side project
category: experiments
importance: 3
---

<img class="project-hero" src="{{ '/assets/img/projects/ljay.png' | relative_url }}" alt="Ljay: live DJ lyrics and visuals" />

<div class="project-facts">
  <div><span class="k">Status</span>early scaffold, v0.1, Mac only</div>
  <div><span class="k">Stack</span>Swift Now Playing helper, Node sidecar, Vite, three.js, Web Audio, LRCLIB</div>
  <div><span class="k">Works with</span>Djay Pro, Serato, Rekordbox, Traktor, Music.app, Spotify, browser tabs</div>
</div>

<div class="project-links">
  <a href="https://github.com/HaukeCornell/Ljay" target="_blank" rel="noopener">Code</a>
</div>

Ljay puts lyrics and visuals behind a DJ set without touching the DJ software. A small Swift helper reads whatever macOS Now Playing reports, so it works with Djay Pro, Serato, Rekordbox, Traktor, Music.app, Spotify, or a browser tab. A Node sidecar forwards the current track to a browser renderer, which fetches time-synced lyrics from LRCLIB and shows them karaoke-style over a visual scene.

The scenes react to the music. Chrome captures the master output through a loopback device such as BlackHole, runs an FFT, and feeds the bands into three.js presets (Winamp, Tunnel, and Minimal so far). Without a loopback the visuals fall back to a synthetic 120 BPM beat so development keeps moving. Hotkeys toggle lyrics, cycle scenes, go fullscreen, and nudge the sync.

It is a day-one spike from April 2026 and much of it is still stubs. The plan files in the repository say where it is going.

<!--
Demo video: drop the file in assets/video/ and uncomment.
<video class="project-hero" controls preload="metadata" src="{{ '/assets/video/ljay.mp4' | relative_url }}"></video>
-->
