# Prepare
{classname,moment,items,itemClassname,activeItem,activeClassname,inactiveClassname,type,showDate,showDescription,showContent,emptyText,dateFormat} = @
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
		div ".list-#{type}-empty", ->
			emptyText
		return

	# Exists
	items.forEach (item) ->
		# Item
		{url,title,date,description,contentRenderedWithoutLayouts} = item.attributes

		# Classname
		itemClassnames = ["list-#{type}-item"]
		itemClassnames.push(itemClassname)  if itemClassname
		itemStatusClassname = if item.id is activeItem?.id then activeClassname else inactiveClassname
		itemClassnames.push(itemStatusClassname)  if itemStatusClassname

		# Display
		li "."+itemClassnames.join('.'), "typeof":"soic:page", about:url, ->
			# Link
			a ".list-#{type}-link", href:url, ->
				# Title
				span ".list-#{type}-title", property:"dc:title", -> title

				# Date
				if showDate and moment
					span ".list-#{type}-date", property:"dc:date", ->
						moment(date).format(dateFormat)

			# Display the description if it exists
			if showDescription and description
				div ".list-#{type}-description", property:"dc:description", -> description

			# Display the content if it exists
			if showContent and item.contentRenderedWithoutLayouts
				div ".list-#{type}-content", property:"dc:content", -> contentRenderedWithoutLayouts
