# Separate Front Matter

Jekyll currently assumes that meta data about pages and posts stored as a "front matter" block at the top of the document.

There have been a few requests about keeping this meta data in a separate yaml file, but currently, this is not implemented.

Front matter is not part of any markdown standard, which is a valid reason to avoid it in your markdown pages.

One way to avoid using front matter is by using the "optional-front-matter" plugin. In this case, the title comes from the page heading.

But if you would like additional page attributes, this is not sufficient.

There is a simple way to acheive external meta data.  In each page directory, we can use a convention where the page document is stored in README.md, and a a front matter wrapper is in index.md.

The index.md would have front matter definitions, followed by a include_relative README.md.

This works because index.md takes precedence over README.md in jekyll, and jekyll properly generates html from the included README.md.
