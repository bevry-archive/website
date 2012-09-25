###
layout: default
###

div '.container', ->
	header '.topbar', ->
		h1 '.heading.hover-link', 'data-href':'/', ->
			@text['heading']
		h2 '.subheading', @text['subheading']
		h3 '.account', @text['myaccount']

	div '.sidebar', ->
		nav '.navbar', ->
			text @partial('list/menu.html.coffee',{
				items: @getCollection('pages').toJSON()
				activeItemID: @document.id
				partial: @partial
				moment: @moment
			})

	div '.mainbar', ->
		@content

	footer ".bottombar", ->
		p ".copyright", @text['copyright']
		p ".poweredby", @text['poweredby']