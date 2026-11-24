import { highlightSearchTerm } from "./highlight-search-term.js";

// Filters the publication list two ways, combined: a text search (the
// #bibsearch input, or a #hash) and a theme chip (.bib-themes buttons, or
// #theme=key). Entries carry their themes in a data-themes attribute, on the
// entry itself or on a child element.
document.addEventListener("DOMContentLoaded", function () {
  const input = document.getElementById("bibsearch");
  const themeNav = document.querySelector(".bib-themes");
  const ENTRY_SELECTOR = ".bibliography > li, .under-review > li";
  let activeTheme = "";

  const entries = () => Array.from(document.querySelectorAll(ENTRY_SELECTOR));
  const themesOf = (li) => {
    const el = li.hasAttribute("data-themes") ? li : li.querySelector("[data-themes]");
    return el
      ? el
          .getAttribute("data-themes")
          .split(/[\s,]+/)
          .filter(Boolean)
      : [];
  };

  // Text pass: hide entries whose text does not contain the search term.
  const applySearch = (rawTerm) => {
    const term = rawTerm.toLowerCase();
    if (!term) {
      if (CSS.highlights) CSS.highlights.delete("search");
      return;
    }
    // Special case: the term is a bib entry id (e.g. arrived here from a
    // mentee-page paper chip). The raw key is not part of any entry's visible
    // text, so the plain substring search would otherwise hide everything.
    const idTarget = document.getElementById(rawTerm) || document.getElementById(term);
    const targetLi = idTarget ? idTarget.closest(".bibliography > li") : null;
    if (targetLi) {
      entries().forEach((li) => {
        if (li !== targetLi) li.classList.add("unloaded");
      });
      return;
    }
    if (CSS.highlights) {
      const nonMatching = highlightSearchTerm({ search: term, selector: ENTRY_SELECTOR });
      (nonMatching || []).forEach((el) => el.classList.add("unloaded"));
    } else {
      // Browser without the CSS Custom Highlight API: plain substring match.
      entries().forEach((li) => {
        if (li.innerText.toLowerCase().indexOf(term) == -1) li.classList.add("unloaded");
      });
    }
  };

  // Theme pass: hide entries that do not carry the active theme.
  const applyTheme = () => {
    if (!activeTheme) return;
    entries().forEach((li) => {
      if (!themesOf(li).includes(activeTheme)) li.classList.add("unloaded");
    });
  };

  const hideEmptyGroups = () => {
    // al-folio year groups: h2.bibliography followed by h3 and ol elements.
    document.querySelectorAll("h2.bibliography").forEach(function (element) {
      let iterator = element.nextElementSibling;
      let hideFirstGroupingElement = true;
      while (iterator && iterator.tagName !== "H2") {
        if (iterator.tagName === "OL") {
          const ol = iterator;
          const unloadedSiblings = ol.querySelectorAll(":scope > li.unloaded");
          const totalSiblings = ol.querySelectorAll(":scope > li");
          if (unloadedSiblings.length === totalSiblings.length) {
            ol.previousElementSibling.classList.add("unloaded");
            ol.classList.add("unloaded");
          } else {
            hideFirstGroupingElement = false;
          }
        }
        iterator = iterator.nextElementSibling;
      }
      if (hideFirstGroupingElement) {
        element.classList.add("unloaded");
      }
    });
    // Type sections on the publications page: h2.pubtype directly followed by its list.
    document.querySelectorAll("h2.pubtype").forEach((heading) => {
      const list = heading.nextElementSibling;
      if (!list || (list.tagName !== "OL" && list.tagName !== "UL")) return;
      const items = list.querySelectorAll(":scope > li");
      const hidden = list.querySelectorAll(":scope > li.unloaded");
      if (items.length > 0 && hidden.length === items.length) {
        heading.classList.add("unloaded");
        list.classList.add("unloaded");
      }
    });
  };

  const filterItems = (rawTerm) => {
    document.querySelectorAll(".bibliography, .unloaded").forEach((element) => element.classList.remove("unloaded"));
    applySearch(rawTerm || "");
    applyTheme();
    hideEmptyGroups();
  };

  const setTheme = (theme, updateHash) => {
    if (!themeNav || !themeNav.querySelector('.bib-theme[data-theme="' + theme + '"]')) theme = "";
    activeTheme = theme;
    if (themeNav) {
      themeNav.querySelectorAll(".bib-theme").forEach((btn) => {
        btn.setAttribute("aria-pressed", String(btn.dataset.theme === theme));
      });
    }
    if (updateHash) {
      history.replaceState(null, "", theme ? "#theme=" + theme : window.location.pathname + window.location.search);
    }
    filterItems(input.value);
  };

  if (themeNav) {
    const counts = {};
    entries().forEach((li) => {
      themesOf(li).forEach((t) => {
        counts[t] = (counts[t] || 0) + 1;
      });
    });
    themeNav.querySelectorAll(".bib-theme").forEach((btn) => {
      const count = btn.querySelector(".count");
      if (count && btn.dataset.theme) count.textContent = counts[btn.dataset.theme] || 0;
      // Clicking the active chip again goes back to all.
      btn.addEventListener("click", () => setTheme(btn.dataset.theme === activeTheme ? "" : btn.dataset.theme, true));
    });
    themeNav.hidden = false;
  }

  const updateFromHash = () => {
    const hashValue = decodeURIComponent(window.location.hash.substring(1));
    if (hashValue.startsWith("theme=")) {
      input.value = "";
      setTheme(hashValue.slice("theme=".length), false);
      return;
    }
    input.value = hashValue;
    filterItems(hashValue);
  };

  // Only start filtering once there has been no input for 300 ms.
  let timeoutId;
  input.addEventListener("input", function () {
    clearTimeout(timeoutId);
    const value = this.value;
    timeoutId = setTimeout(() => filterItems(value), 300);
  });

  window.addEventListener("hashchange", updateFromHash);
  updateFromHash();
});
