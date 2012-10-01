###
layout: structure
###

text @partial('content/block.html.coffee',{
	className: ".doc"
	permalink: @document.url
	heading: @getTitle(@documentModel)
	subheading: @document.subheading
	content: @content
	prev: 'Quickstart'
	next: 'Beginner Guide'
})