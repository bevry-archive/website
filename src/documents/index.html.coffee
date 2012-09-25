---
layout: structure
title: Welcome
---

@getCollection('pages').toJSON().forEach (item) =>
	text @partial('content/page.html.coffee',{item,partial:@partial})