// Initialize GLightbox for click-to-enlarge photos.
//
// Markup pattern in news posts (and future blog posts):
//   <a class="zoom-photo" href="/path/to/full.jpg">
//     <img src="/path/to/full-sdr.jpg" alt="…" style="width: 90px; …" />
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
//
// Caption: instead of GLightbox's default `title` tooltip text, we derive
// the caption from the surrounding news-post body so the lightbox always
// shows the same context the user was reading next to the thumbnail.
document.addEventListener("DOMContentLoaded", function () {
  if (typeof GLightbox === "undefined") return;

  document.querySelectorAll("a.zoom-photo").forEach(function (anchor) {
    // Drop any misleading hover text — the lightbox caption replaces it.
    anchor.removeAttribute("title");

    // The news.liquid template renders each post body inside a <td>; the
    // post date lives in a sibling <th>. Caption = the cell HTML minus
    // the anchor itself, so the visible news text becomes the caption.
    var cell = anchor.closest("td");
    if (!cell) return;
    var clone = cell.cloneNode(true);
    clone.querySelectorAll("a.zoom-photo").forEach(function (n) {
      n.remove();
    });
    var html = clone.innerHTML.trim();
    if (html) anchor.setAttribute("data-description", html);
  });

  window.lightbox = GLightbox({
    selector: ".zoom-photo",
    touchNavigation: true,
    loop: false,
    zoomable: true,
    moreLength: 0, // disable "See more" truncation of long captions
  });
});
