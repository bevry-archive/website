###
layout: default
###

div '.container', ->
	header '.topbar', ->
		h1 '.heading.hover-link', 'data-href':'/', ->
			@text['heading']
		h2 '.subheading', @text['subheading']

	aside '.accountbar', ->
		div '.heading-background', ->
		header '.heading', ->
			span '.title', @text['myaccount']
			span '.icon', ->
		div '.content', ->
			text @partial('content/user.html.coffee',{
				user: false
			})

	div '.sidebar', ->
		pages = @getCollection('pages')
		activeItemURL = '/'+@document.url.split('/')[1]
		activeItem = if activeItemURL isnt '/' then pages.findOne(url: $startsWith: activeItemURL) else pages.findOne(url:activeItemURL)
		text @partial('list/menu.html.coffee',{
			classname: "navbar"
			items: pages
			activeItem: activeItem
			partial: @partial
			moment: @moment
		})

		nav ".promos", ->
			for own key,promo of @promos
				a ".promo.hover-link", "href":promo.url, ->
					span ".title", -> promo.title
					span ".description", -> promo.description

	div '.mainbar', ->
		div "#content", -> @content
		footer ".bottombar", ->
			p ".poweredby", @text['poweredby']
			p ".copyright", @text['copyright']
