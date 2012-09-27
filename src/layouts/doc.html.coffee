###
layout: structure
###

text @partial('content/block.html.coffee',{
	heading: @getTitle(@documentModel)
	subheading: @document.subheading
	content: @content
})