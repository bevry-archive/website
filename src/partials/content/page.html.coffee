text @partial('content/block.html.coffee',{
	heading: @item.title
	subheading: @item.subheading
	content: @item.contentRenderedWithoutLayouts
})