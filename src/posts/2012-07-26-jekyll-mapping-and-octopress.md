---
title: "Jekyll-Mapping and Octopress"
date: 2012-07-26 11:11
categories:
    - development
    - octopress
---

For a while now, I've been wanting to add some sort of maps support to
[octopress](http://octopress.org/)/[jekyll](https://github.com/mojombo/jekyll),
and I finally recently had some time to look into it a little bit more.
It seems some others out there have had the same idea, because I stumbled
across two plugins that did something close (but not exactly) to what I wanted:
[octolayer](https://github.com/mguentner/octolayer) and
[jekyll-mapping](https://github.com/matthewowen/jekyll-mapping).

The reason I'm interested in this is that when I travel, I like to log `gpx`
tracks of the places we go, and geotag my photos, etc.  It's nice to be able to
display a map of where I went each day, and I can always go back and find
exactly where that awesome restaurant was (in case I go back, or to tell
friends).

I wasn't really sure how/if jekyll plugins would map to octopress (since
octopress does use jekyll, but its plugin structure still seems to be slightly
different), so I started off looking into octolayer.

## Octolayer

Octolayer was only setup to use [openlayers](http://openlayers.org/), and it
could only do specific long/lat co-ordinates.  I really wanted to be able to use
google maps, but I figured i'd give this a try and see how things went.

I liked the way that octolayer was set up, and the ease of installing it, but
the openlayers API looked really messy to me, and I didn't feel like spending a
bunch of time learning it when I really wanted google maps anyway, so I opened
up an [issue](https://github.com/matthewowen/jekyll-mapping/issues/1) with
[matthewowen](https://github.com/matthewowen/) to see what his
thoughts were about adding the functionality I wanted to `jekyll-mapping`.

## Jekyll-Mapping

Matthew responded pretty quickly, and showed me that he really already had basic
support for what I wanted.  Fantastic.  All you had to do was put this in your
config section of your posts:

```
mapping:
    layers:
        - http://path/to/kml_file.kml
        - http://path/to/gpx_file.gpx
```

Then put this in your post body wherever you want the map to render:

```
{% raw %}{% render_map %}{% endraw %}
```

That's it!  It seemed to work pretty well at first, but then I quickly realized
that the way the code was set up, it would only work on the post page, and would
not be able to display multiple maps on a page that lists several posts (or even
one post with multiple maps).  The javascript used an id to find the
`jekyll-mapping` element, and it was tightly bound to a single-post page.

I decided to head into `#octopress` and ask around (I've never mucked with
octopress source or plugins before), and got some really useful tips and help
from [Brandon Mathis](https://github.com/imathis), Octopress' creator.

After a bit of tinkering, I ended up with
[this changeset](https://github.com/throughnothing/jekyll-mapping/compare/refactor)
that gave me pretty much everything I wanted (for now):

<script src="https://gist.github.com/throughnothing/3183238.js"></script>

With this, I can put multiple layers on a map (I usually put a `.gpx` layer for
the day, as well as a layer from flickr with my geotagged photoset for that day
in each relevant post), and display multiple posts, each with a map, per page.

