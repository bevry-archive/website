text @partial('list/items.html.coffee',{
	type: 'menu'
	items: @items
	showDescription: false
	showDate: false
	moment: @moment
})