$ ->
	# Prepare
	$body = $(document.body)
	$window = $(window)
	$docnav = $('.docnav')
	$docnavUp = $docnav.find('.up')
	$docnavDown = $docnav.find('.down')
	$docSectionWrapper = $('<div class="section-wrapper">')
	$article = null
	$docHeaders = null
	$docSections = null

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

	# Docnav
	$docnavUp.addClass('active').click ->
		$lastHeader = null
		$docHeaders.each ->
			$header = $(this)
			if $header.offset().top < window.scrollY
				$lastHeader = $header
			else
				return false
		if $lastHeader
			$lastHeader.click()
		else
			$body.ScrollTo()

	$docnavDown.addClass('active').click ->
		if $docSections.filter('.active:last').nextAll('h2:first').click().length is 0
			$lastHeader = null
			$docHeaders.each ->
				$header = $(this)
				if $header.offset().top > (window.scrollY + (window.innerHeight or document.documentElement.clientHeight))
					$lastHeader = $header
					return false
			if $lastHeader
				$lastHeader.click()
			else
				$body.ScrollTo()

	# Listen to history.js page changes
	$window.on 'statechangecomplete', ->
		# Special handling for long docs
		$article = $('article:first')

		if $article.is('.block.doc')
			$docHeaders = $article.find('h2')
				.addClass('hover-link')
				.each (index) ->
					$header = $(this)
					$header.nextUntil('h2').wrapAll($docSectionWrapper.clone().attr('id','h2-'+index))
				.click (event,opts) ->
					$header = $(this)
					$header
						.prevAll('.section-wrapper')
							.addClass('active')
							.end()
						.next('.section-wrapper')
							.addClass('active')
					$header.ScrollTo()  if !opts or opts.scroll isnt false
			$docSections = $article.find('.section-wrapper')
			$docHeaders.first().trigger('click',{scroll:false})
		else
			$docHeaders = null
			$docSections = null

		if $docHeaders and $docHeaders.length isnt 0
			$docnav.addClass('active')
		else
			$docnav.removeClass('active')


	# Always trigger initial page change
	$window.trigger('statechangecomplete')