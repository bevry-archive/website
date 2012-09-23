text @partial('list/items.html.coffee',{
	type: 'menu'
	items: @items
	activeItemID: @activeItemID
	showDescription: false
	showDate: false
	moment: @moment
})