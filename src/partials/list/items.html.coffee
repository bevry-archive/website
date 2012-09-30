# Prepare
{classname,moment,items,activeItemID,activeClassname,inactiveClassname,type,showDate,showDescription,showContent,emptyText,dateFormat} = @
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
		itemClassname = if item.id is activeItemID then activeClassname else inactiveClassname
		li ".list-#{type}-item"+(if itemClassname then '.'+itemClassname else ''), "typeof":"soic:page", about:item.url, ->
			# Link
			a ".list-#{type}-link", href:item.url, ->
				# Title
				span ".list-#{type}-title", property:"dc:title", ->
					item.title

				# Date
				if showDate
					span ".list-#{type}-date", property:"dc:date", ->
						moment(item.date).format(dateFormat)

			# Display the description if it exists
			if showDescription and item.description
				p ".list-#{type}-description", property:"dc:description", ->
					item.description

			# Display the content if it exists
			if showContent and item.contentRenderedWithoutLayouts
				p ".list-#{type}-content", property:"dc:content", ->
					item.contentRenderedWithoutLayouts
