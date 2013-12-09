###
layout: default
###

div '.container', ->
	header '.topbar', ->
		h1 '.heading.hover-link', 'data-href':'/', ->
			@text['heading']
		h2 '.subheading', @text['subheading']

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
					span ".description", ->
						if promo.description
							text promo.description
						else
							if promo.date
								if new Date(promo.date) < new Date()
									text "Happened on #{promo.date} "
								else
									text "Happening on #{promo.date} "
							if promo.location
								text "in #{promo.location}"

	div '.mainbar', ->
		div "#content", -> @content
		footer ".bottombar", ->
			div ".poweredby", @text['poweredby']
			div ".copyright", @text['copyright']
