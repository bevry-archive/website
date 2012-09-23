###
layout: default
###

div '.container', ->
	header '.topbar', ->
		h1 '.heading', @text['heading']
		h2 '.subheading', @text['subheading']
		h3 '.account', @text['myaccount']

	div '.sidebar', ->
		nav '.navbar', ->
			text @partial('list/menu.html.coffee',{
				items: @getCollection('pages').toJSON()
				partial: @partial
				moment: @moment
			})

	div '.mainbar', ->
		text @partial('content/block.html.coffee',{
			heading: @document.title
			subheading: @document.subheading
			content: @content
		})