---
layout: nav
---

# Writing

<ul class="posts">
{% for p in collections.posts | reverse %}
  <li><a href="{{ p.url }}">{{ p.data.title }}</a></li>
{% endfor %}
</ul>