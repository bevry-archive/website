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

	# Special handling for long docs
	$docSectionWrapper = $('<div class="section-wrapper">')
	$docSectionWrappers = null
	$('article.block h2').addClass('hover-link').each(->
		$h2 = $(this)
		$h2.nextUntil('h2').wrapAll($docSectionWrapper)
	).click(->
		$h2 = $(this)
		$h2.next().show().siblings('.section-wrapper').hide()
		$h2.ScrollTo()
	).first().trigger('click')