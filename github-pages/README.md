# Website creation using Github Pages

*by Don Mahurin, 2022-09-17*

This article gives some simple steps on how to use github pages for your website.

Previously, I used just plain html for openright.org, then to make the pages easier to edit, some were converted to simple markup (textile).

I  was aware that my pages were boring, and not pretty. I also knew of github pages, and decided to try it for my website.

Some desired conditions of the pages:
- Stored in git
- Simple markdown
- Easy to edit
- Easy to view locally
- Looks "good/ok"

The first step, creating a github pages project, is easy enough. (https://pages.github.com/). Just create a 'something.github.io' project, and enable github pages.

And by default, one can just put markdown files there (index.md, or README.md), and they show up.

But they do not look like a web page.

For pages, github is using Jekyll. It looked like I needed to set that up more properly.

In experimenting with Jekyll, there were some things to note:
- Jekyll assumed the use of "Front Matter" headers on markup pages to get meta data like title, date ...
- Github pages uses a specific version of Jekyll with a select group of plugins available
- To view locally, the plugins and versions used need to align

"Front Matter" is not in any markdown standard, including Github's. If possible, I wanted to avoid it, and keep with simple markdown.

And we needed a simple way to use the github aligned Jekyll and plugins.

Fast-forwarding to the solution...

The following Gemfile depends on 'github-pages', which depends on the same Jekyll versions and plugins that github uses.

It also includes a plugin which makes front matter optional.

Gemfile
```
source "https://rubygems.org"

gem "webrick"

gem "jekyll-remote-theme"
gem "jekyll-default-layout"
gem "jekyll-optional-front-matter"

gem "github-pages", group: :jekyll_plugins
```

The following config file:
- Uses GFM markdown (rather than kramdown)
- Uses Minima theme
- Enables proper functionality without front matter

_config.yml
```
markdown: GFM

remote_theme: jekyll/minima

minima:
  skin: auto

plugins:
  - jekyll-remote-theme
  - jekyll-optional-front-matter
  - jekyll-default-layout
```

To setup your site, add the Gemfile and _config.yml above, then add some markdown (index.md or README.md).

To get GFM markdown from existing html pages, you may use:
```
markdownify | pandoc -f markdown -t gfm
```

Then run

```
bundle config set --local path vendor/bundle
bundle install --path vendor/bundle
bundle exec jekyll serve
```

My pages are likely still boring, though I hope you have learned something new about setting up github/jekyll pages.
