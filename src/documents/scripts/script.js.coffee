$ ->
	# Prepare
	$body = $(document.body)

	# Link handling
	$body.on 'click', '[data-href],[href]:not(a)', ->
		# Prepare
		href = $(this).data('href')

		# Open link in new tab
		if event.which is 2 or event.metaKey
			window.open(href,'_blank');

		# Open link in the same tab
		else
			window.location.href = href

	# Sidebar fadeout
	$sidebar = $('.sidebar')
	$sidebar.animate({opacity:0.5},3000).hover(
		->
			$sidebar.stop(true,false).animate({opacity:1},500)
		->
			$sidebar.stop(true,false).animate({opacity:0.5},2000)
	)

	# Special handling for long docs
	$docSectionWrapper = $('<div class="section-wrapper">')
	$docSectionWrappers = null
	$('article.block.doc h2').addClass('hover-link').each(->
		$h2 = $(this)
		$h2.nextUntil('h2').wrapAll($docSectionWrapper)
	).click(->
		$h2 = $(this)
		$h2.next().show().siblings('.section-wrapper').hide()
		$h2.ScrollTo()
	).first().trigger('click')