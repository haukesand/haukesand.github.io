// Initialize medium zoom.
//
// Safari rasterises images at their displayed size before applying CSS
// transforms — medium-zoom uses transform: scale() to enlarge, so a small
// thumbnail zooms to a soft, blurry raster on Safari (and any iOS browser,
// since iOS Chrome/Firefox are WebKit under the hood). Chrome/Edge/Firefox
// on desktop re-rasterise on transform and look crisp.
//
// Strategy: for images marked with class "zoom-photo" we ship a plain
// <a href="...">…</a> wrapper that opens the original file in a new tab.
// On non-WebKit browsers we promote them to medium-zoom for the nicer
// in-page lightbox; WebKit keeps the link fallback.
$(document).ready(function () {
  var isWebKit = navigator.vendor && navigator.vendor.indexOf("Apple") !== -1;

  if (!isWebKit) {
    document.querySelectorAll("a.zoom-photo > img").forEach(function (img) {
      img.setAttribute("data-zoomable", "");
      // Intercept the anchor's default navigation so the lightbox wins.
      img.parentElement.addEventListener("click", function (e) {
        e.preventDefault();
      });
    });
  }

  medium_zoom = mediumZoom("[data-zoomable]", {
    background: getComputedStyle(document.documentElement).getPropertyValue("--global-bg-color") + "ee", // + 'ee' for trasparency.
  });
});
