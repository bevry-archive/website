---
title: Blog
layout: page
url: '/blog/'
ignore: true
---

posts = @getCollection('posts')
text @partial 'list/items.html.coffee', {
	items: posts
	showContent: true
	showDescription: true
	itemClassname: 'subblock'
}