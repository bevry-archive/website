text @partial('list/items.html.coffee',{
	type: 'menu'
	items: @items
	activeItem: @activeItem
	showDescription: false
	showDate: false
	moment: @moment
})