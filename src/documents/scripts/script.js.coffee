$ ->
	# Prepare
	$body = $(document.body)
	$window = $(window)
	$docnav = $('.docnav')
	$docnavUp = $docnav.find('.up')
	$docnavDown = $docnav.find('.down')
	$docSectionWrapper = $('<div class="section-wrapper">')
	$account = $('.accountbar')
	$accountContent = $account.find('.content')
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
		$current = $docHeaders.filter('.current')
		if $current.length
			$prev = $current.prevAll('h2:first')
			if $prev.length
				$prev.click()
			else
				$docHeaders.filter('.current').removeClass('current')
				$body.ScrollTo()
	$docnavDown.addClass('active').click ->
		$current = $docHeaders.filter('.current')
		if $current.length
			$next = $current.nextAll('h2:first')
			if $next.length
				$next.click()
			else
				$current.click()
		else
			$docHeaders.first().click()

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
					$docHeaders.filter('.current').removeClass('current')
					$header = $(this)
						.addClass('current')
						.stop(true,false).css({'opacity':0.5}).animate({opacity:1},1000)
						.prevAll('.section-wrapper')
							.addClass('active')
							.end()
						.next('.section-wrapper')
							.addClass('active')
							.end()
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

	# Load the user
	$.get '/user/', (data) ->
		$accountContent.html(data)

	# Always trigger initial page change
	$window.trigger('statechangecomplete')