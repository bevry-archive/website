###
layout: structure
###

text @partial('content/block.html.coffee',{
	className: ".page"
	heading: @document.title
	subheading: @document.subheading
	content: @content
})