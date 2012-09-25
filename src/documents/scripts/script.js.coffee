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