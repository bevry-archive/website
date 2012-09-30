###
layout: default
###

div '.container', ->
	header '.topbar', ->
		h1 '.heading.hover-link', 'data-href':'/', ->
			@text['heading']
		h2 '.subheading', @text['subheading']
		h3 '.account', ->
			span '.text', @text['myaccount']
			span '.icon', -> '▴'

	div '.sidebar', ->
		text @partial('list/menu.html.coffee',{
			classname: "navbar"
			items: @getCollection('pages').toJSON()
			activeItemID: @document.id
			partial: @partial
			moment: @moment
		})

	div '#content.mainbar', ->
		@content

	footer ".bottombar", ->
		p ".copyright", @text['copyright']
		p ".poweredby", @text['poweredby']

	aside '.specialbar', ->
		nav ".docnav", ->
			div ".up", -> '⇧'
			div ".down", -> '⇧'