---
layout: page
title: Welcome
---

text @partial('list/items.html.coffee',{
	items: @getCollection('pages').toJSON()
	partial: @partial
	moment: @moment
	showDate: false
	showDescription: false
	showContent: true
})