// Initialize GLightbox for click-to-enlarge photos.
//
// Markup pattern in news posts (and future blog posts):
//   <a class="zoom-photo" href="/path/to/full.jpg">
//     <img src="/path/to/full.jpg" alt="…" style="width: 90px; …" />
//   </a>
//
// GLightbox intercepts the anchor click and shows the full image in a
// proper lightbox. If GLightbox fails to load for any reason, the anchor
// still works as a plain link, so the photo remains accessible.
//
// We switched here from medium-zoom because Safari/WebKit rasterises images
// at their displayed size before applying CSS transforms; medium-zoom uses
// transform: scale() to enlarge, producing a blurry zoom on Safari and any
// iOS browser. GLightbox uses width/height transitions instead.
document.addEventListener("DOMContentLoaded", function () {
  if (typeof GLightbox === "undefined") return;
  window.lightbox = GLightbox({
    selector: ".zoom-photo",
    touchNavigation: true,
    loop: false,
    zoomable: true,
    moreLength: 0,
  });
});
