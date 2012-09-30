# Prepare
page = parseInt((@page or @req.query.page or 1), 10)
limit = parseInt((@limit or @req.query.limit or 10), 10)
items = @items
itemsInPage = items.createChildCollection().setPaging({limit,page}).query()
itemsInNextPage=  items.createChildCollection().setPaging({limit,page+1}).query()

# Page navigation item
nav '.paging-pages', ->
	# Display the list of items on the current page
	text @partial('list/items.html.coffee',{items},true)

	# Display the previous and next page links
	if page > 1
		a '.prev', href:"?page=#{page-1}", -> "previous"

	if itemsInNextPage.length
		a '.next', href:"?page=#{page+1}", -> "next"

