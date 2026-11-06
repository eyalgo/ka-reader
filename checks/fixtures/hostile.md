# Hostile corpus

This file holds each hostile piece the renderer must keep inert. The images and the link target it names are
not committed; the test that reads this file makes them in a folder of its own.

A script, as a block of its own:

<script>alert(1)</script>

An event attribute, inside a paragraph: Click <b onclick="steal()">here</b> to continue.

A frame:

<iframe src="https://example.com/frame"></iframe>

A style:

<style>body { display: none }</style>

A raw HTML block:

<div class="box">
raw block content
</div>

A remote image: ![remote](https://example.com/remote.png)

An in-folder PNG: ![logo](logo.png)

An in-folder SVG: ![diagram](diagram.svg)

A `..` image path: ![climb](../outside.png)

A symlink-out image: ![escape](escape.png)

An external link: [example](https://example.com/page)

A relative link: [other](other.md)
