# Prepare
{cssClasses,items,itemCssClasses,emptyText,type} = @
type or= 'images'
emptyText or= "empty"

# Document List
nav ".list-#{type}"+(if cssClasses then "."+cssClasses.join('.') else ''), ->
	# Empty
	unless items.length
		div ".list-#{type}-empty", ->
			emptyText
		return

	# Exists
	items.forEach (item) ->
		# Item
		{url,title,imageUrl} = item

		# CssClasses
		_itemCssClasses = ["list-#{type}-item"]
		_itemCssClasses.concat(itemCssClasses)

		# Display
		li "."+_itemCssClasses.join('.'), title:title, ->
			# Link
			a ".list-#{type}-link", href:url, ->
				# Title
				img ".list-#{type}-image", src:imageUrl, alt:title