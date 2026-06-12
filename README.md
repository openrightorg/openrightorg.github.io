This site is about open information, AI, and other interesting topics.

May you find the information that you seek and stay curious.

---

Search this site or others using <a href="https://search.openright.org"><font style="font-weight: 100;">Thin</font> Search</a>

<div class="container">
  <style scoped>
:root { color-scheme: light dark; }
.search-row { max-width:800px; display:flex; gap:8px; align-items:center; }
input[type="text"]{ flex:1; padding:10px; font-size:16px; }
button{ padding:10px 12px; }
.popup { border: 1px solid; z-index: 1000; }
.popup ul { list-style:none; margin:0; padding:0; max-height:240px; overflow:auto; }
.popup li { padding:8px 12px; border-bottom:1px solid #f1f1f1; cursor:pointer; display:flex; justify-content:space-between; }
.popup li.highlight { background: rgba(128,128,128,0.50); }
.hidden { display:none; }
.container { position:relative; max-width:800px; }
</style>
  <form id="searchForm" onsubmit="return handleSearch(event);">
    <div class="search-row">
      <input name="search" id="q" type="text" value="site:openright.org AI" placeholder="Type a search or ! to see bangs (e.g. '!a headphones' or 'amazon headphones')"/>
      <button type="submit">Go</button>
      <a style="text-decoration: none; appearance: button; border: 1px; color: #7777;" href="?settings" title="Settings">☰</a>
    </div>
  </form>

  <div id="popup" class="popup hidden" role="listbox" aria-live="polite">
    <ul id="popupList"></ul>
  </div>
</div>

<script src="https://search.openright.org/thinsearch.js"></script>

