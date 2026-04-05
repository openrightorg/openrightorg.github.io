# 🌿 Thin Search – Search the Web Without a Search Engine

**Thin Search** is a single‑file, server‑less search UI that lives entirely in your browser. Drop the file on a local drive or host it on any static‑file server and you have a fast, privacy‑friendly search bar that can redirect you to your favourite sites, evaluate math on‑the‑fly, and even talk to local AI models – all without ever hitting a search engine.

### Want to try Thin Search?
* **Live demo**: <https://search.openright.org/> – try it now in your browser.
* **Clone the repo**: <https://github.com/openrightorg/thinsearch> and drop `index.html` on your local machine or any static‑file server.

---

## The Problem: A Concentrated Web

The growth of the internet has not necessarily led to more diversity of information sources. Instead we often see that information has consolidated or concentrated into fewer places. When you type something into a browser, many of the results come from a handful of sites (Stack Overflow, Reddit, Amazon, YouTube, etc.). Search sites like DuckDuckGo and Brave allow you to take advantage of that, and conveniently search directly with *bang* style shortcuts, like ``!g cats`` or ``!r questions`` to jump straight to a particular site. Some browsers even allow configuration of ``:key`` style shortcuts. After getting accustomed to such bangs or shortcuts, we may ask why we need a search engine at all, especially in the age of AI.

In short: we now live in a world where *search* is more about **redirecting** than *finding*. Thin Search gives you a lightweight, privacy‑friendly way to do this with a single HTML file.

## Why we use search engines

Think of some scenarios that drive you to a search engine:

1. **Shopping** – find the best price, compare models, read reviews.
2. **Recipes** – hunt for ingredients, substitutions, and cooking tips.
3. **Tech questions** – search for code snippets, documentation, or stack‑overflow answers.
4. **Quick calculations** – using the browser is easier than a calculator.

But the reality? You often know what you are looking for and where to look. Or it is a trivial question. Or it is best answered with AI.
Either way, the search engine is often just thin redirection – so let’s make it thinner.

## What Thin Search can do for you

Thin Search combines the best parts of a search engine and a personal shortcut manager:

* **Bang‑style searches** – type ``!a shoes`` or ``amazon shoes`` to instantly redirect to a search on the target site.
* **Built‑in bangs** – dozens of common sites with aliases for quick access (Amazon, DuckDuckGo, YouTube, etc.).
* **Category‑aware suggestions** – when you start typing a query, the UI looks for a matching category (e.g. *recipe* ➜ food sites) and shows only bangs that belong to that category.
* **Custom bangs** – edit, add, or delete bangs via the Settings page.
* **Safe expression evaluation** – evaluate math expressions and unit conversions locally.
* **AI integration** – point a bang to your preferred AI provider, including a local provider like Llama.cpp llama-server.
* **Privacy‑friendly** – no additional search cookies or analytics. All logic stays in the browser. all data is stored in ``localStorage`` and never leaves your machine.
* **Single‑file, no build step** – just drop the file anywhere.
* **Privacy‑friendly** – all data is stored in ``localStorage`` and never leaves your machine.

## How Thin Search works

1. **Open `index.html`** in any modern browser.
2. In the search box, type a query or a bang.
   * `!a headphones` ➜ Amazon search for headphones
   * `google cats` ➜ Google search for cats
   * `recipe lasagna` ➜ Shows food‑related bangs (AllRecipes, Epicurious, etc.)
3. Hit **Enter** to perform the search.
4. Click **⚙️ Settings** to edit your list of bangs.

All of the data (bang list, suggestions, etc.) lives in the page itself or in `localStorage`. No server, no build step, no hosting required.

## Why Thin Search is different

Here’s what sets Thin Search apart:

* **Smart shortcut inference** – type a question like *What is a quark?* and Thin Search instantly suggests a bang for an encyclopedia or AI.
* **Fully customizable** – add, edit, or delete bangs in the Settings page. Want a different Wikipedia mirror? No problem.
* **Zero‑tracking** – no additional search cookies or analytics. All logic stays in the browser.
* **Local‑AI integration** – point bangs at your own Llama.cpp or other models for instant answers.
* **Control** – you control your search, rather than a search engine.

In short, Thin Search gives you a lightweight, privacy‑friendly way to find exactly what you need, without the clutter and overhead of a traditional search engine.

---

## Extending Thin Search

The bangs list is embedded in `index.html` under the `<script id="data-json" type="application/json">` element. The JSON schema for each bang is:

```json
{
  "keyword": "site-keyword",
  "alias": "short-alias (optional)",
  "name": "Display name",
  "url": "https://example.com/search?q=%s",
  "category": "category (optional)"
}
```

You can also add or edit bangs via the Settings UI; they are stored in `localStorage` and are therefore browser‑only.

**Repository**: <https://github.com/openrightorg/thinsearch>

