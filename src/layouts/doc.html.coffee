###
layout: structure
###

text @partial('content/block.html.coffee',{
	className: ".doc"
	heading: @getTitle(@documentModel)
	subheading: @document.subheading
	content: @content
})