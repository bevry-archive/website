###
layout: structure
###

text @partial('content/block.html.coffee',{
	heading: @document.title
	subheading: @document.subheading
	content: @content
})