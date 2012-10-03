# Prepare
{classname,moment,items,activeItem,activeClassname,inactiveClassname,type,showDate,showDescription,showContent,emptyText,dateFormat} = @
activeClassname ?= 'active'
inactiveClassname ?= 'inactive'
type or= 'items'
showDate ?= true
showDescription ?= true
showContent ?= false
emptyText or= "empty"
dateFormat or= "YYYY-MM-DD"

# Document List
nav ".list-#{type}"+(if classname then "."+classname else ''), "typeof":"dc:collection", ->
	# Empty
	unless items.length
		p ".list-#{type}-empty", ->
			emptyText
		return

	# Exists
	items.forEach (item) ->
		# Item
		itemClassname = if item.id is activeItem.id then activeClassname else inactiveClassname
		{url,title,date,description,contentRenderedWithoutLayouts} = item.attributes
		li ".list-#{type}-item"+(if itemClassname then '.'+itemClassname else ''), "typeof":"soic:page", about:url, ->
			# Link
			a ".list-#{type}-link", href:url, ->
				# Title
				span ".list-#{type}-title", property:"dc:title", -> title

				# Date
				if showDate
					span ".list-#{type}-date", property:"dc:date", ->
						moment(date).format(dateFormat)

			# Display the description if it exists
			if showDescription and item.description
				p ".list-#{type}-description", property:"dc:description", -> description

			# Display the content if it exists
			if showContent and item.contentRenderedWithoutLayouts
				p ".list-#{type}-content", property:"dc:content", -> contentRenderedWithoutLayouts
