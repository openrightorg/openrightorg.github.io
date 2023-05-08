# Allow page/post comments

To allow comments, we can use github issues, as demonstrated in this article.

https://aristath.github.io/blog/static-site-comments-using-github-issues-api

And just adding one file in our _includes, updated for our site

https://github.com/aristath/aristath.github.com/blob/master/_includes/comments.html

Then we just add comments_ids for our pages, and add this to page.html

```
{% raw %}{% if page.comments_id %}
{% include comments.html %}
{% endif %}{% endraw %}
```
