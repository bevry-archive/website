# Prepare
current = @item
collection = @collection

# Navigation item
nav '.paging-item', ->

	# Cycle through the documents until we get the current document
	collection.forEach (item,index) ->

		# Check if we are the current document
		if item.id is current.id

			# We are, so lets get the previous and next
			prev = collection.at(index-1)
			next = collection.at(index+1)

			# Show the previous page
			if prev
				a '.prev', href:prev.get('url'), ->
					prev.get('title') or prev.get('name')

			if next
				a '.prev', href:next.get('url'), ->
					next.get('title') or next.get('name')

			# Break
			return false