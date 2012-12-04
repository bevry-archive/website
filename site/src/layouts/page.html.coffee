###
layout: structure
###

text @partial('content/block.html.coffee',{
	cssClasses: ['page'].concat(@document.cssClasses or []).concat(@cssClasses or [])
	permalink: @document.url
	heading: @document.title
	subheading: @document.subheading
	content: @content
	author: @document.author
})