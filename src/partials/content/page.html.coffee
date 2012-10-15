text @partial('content/block.html.coffee',{
	cssClasses: ['page'].concat(@item.cssClasses or []).concat(@cssClasses or [])
	permalink: @item.url
	heading: @item.title
	subheading: @item.subheading
	content: @item.contentRenderedWithoutLayouts
	author: @item.author
})