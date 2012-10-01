text @partial('content/block.html.coffee',{
	className: ".page"
	permalink: @item.url
	heading: @item.title
	subheading: @item.subheading
	content: @item.contentRenderedWithoutLayouts
})