# Combining Pages and Posts

The common way to use jekyll is to separately view pages and posts.

Instead, we can merge pages and posts together.  In this way, the page is the main article, and the posts are the followup articles.

To implement this, we display the page content as usual, then we find and display posts with a post url matching the page url.

To get a separation bar, the "site-footer" div is used. This works with the minima theme.

In page.html:

```
{% raw %}{{ content }}
{% for post in site.posts reversed %}
  {% if post.url contains page.url %}

    <div class="site-footer"/>
    <p>{{ post.date | date: "%Y-%m-%d" }}</p>
    <p>{{ post.content }}</p>
  {% endif %}
{% endfor %}{% endraw %}
```
