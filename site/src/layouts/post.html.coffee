###
layout: structure
###

items = @getCollection('posts')
for item,index in items.models
	if item.id is @document.id
		break
prevItem = items.models[index+1] ? null
nextItem = items.models[index-1] ? null

text @partial('content/block.html.coffee',{
	className: ".post"
	moment: @moment
	author: @document.author
	permalink: @document.url
	heading: @document.title
	subheading: @document.subheading
	content: @content
	prev:
		if prevItem
			url: prevItem.attributes.url
			title: prevItem.attributes.title
	next:
		if nextItem
			url: nextItem.attributes.url
			title: nextItem.attributes.title
	up:
		url: "/blog/"
		title: "Blog"
})