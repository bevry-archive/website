###
standalone: true
###

$ ->
	# Prepare
	$document = $(document)
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
	wait = (delay,callback) -> setTimeout(callback,delay)

	# Links
	openLink = ({url,action}) ->
		if action is 'new'
			window.open(url,'_blank')
		else if action is 'same'
			wait(100, -> document.location.href = url)
		return
	openOutboundLink = ({url,action}) ->
		# https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide
		hostname = url.replace(/^.+?\/+([^\/]+).*$/,'$1')
		_gaq?.push(['_trackEvent', "Outbound Links", hostname, url, 0, true])
		openLink({url,action})
		return
	$body.on 'click', 'a[href]:external', (event) ->
		# Prepare
		$this = $(this)
		url = $this.attr('href')
		return  unless url

		# Discover how we should handle the link
		if event.which is 2 or event.metaKey
			action = 'default'
		else
			action = 'same'
			event.preventDefault()

		# Open the link
		openOutboundLink({url,action})

		# Done
		return
	$body.on 'click', '[data-href]', ->
		# Prepare
		$this = $(this)
		url = $this.data('href')
		return  unless url

		# Discover how we should handle the link
		if event.which is 2 or event.metaKey
			action = 'new'
		else
			action = 'same'
			event.preventDefault()

		# Open the link
		if $this.is(':internal')
			openLink({url,action})
		else
			openOutboundLink({url,action})

		# Done
		return

	# Sidebar fadeout
	$sidebar = $('.sidebar')
	$sidebar.animate({opacity:0.5},3000).hover(
		->
			$sidebar.stop(true,false).animate({opacity:1},500)
		->
			$sidebar.stop(true,false).animate({opacity:0.5},2000)
	)

	# Docnav
	upSection = ->
		return  unless $docHeaders?
		$current = $docHeaders.filter('.current')
		if $current.length
			$prev = $current.prevAll('h2:first')
			if $prev.length
				$prev.click()
			else
				$docHeaders.filter('.current').removeClass('current')
				$docHeaders.last().click()
				#$body.ScrollTo()
	downSection = ->
		return  unless $docHeaders?
		$current = $docHeaders.filter('.current')
		if $current.length
			$next = $current.nextAll('h2:first')
			if $next.length
				$next.click()
			else
				#$current.click()
				$docHeaders.first().click()
		else
			$docHeaders.first().click()
	$document.on 'keyup', (event) ->
		console.log(event.metaKey, event.shiftKey, event.keyCode, event)
		if event.altKey
			if event.keyCode is 38  # up
				$('.block-footer a.up').click()
			else if event.keyCode is 37  # left
				$('.block-footer a.prev').click()
			else if event.keyCode is 39  # right
				$('.block-footer a.next').click()
		else if event.shiftKey
			if event.keyCode is 38  # up
				upSection()
			else if event.keyCode is 40  # down
				downSection()


	# Listen to history.js page changes
	$window.on 'statechangecomplete', ->
		# Special handling for long docs
		$article = $('article:first')
		$('.purchase-booking').hide()

		# Booking
		$('.show-booking').click ->
			$('.purchase-booking').slideToggle()

		# Documentation
		if $article.is('.block.doc')
			$docHeaders = $article.find('h2')

			# Compact
			if $article.is('.compact')
				$docHeaders
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
					.first()
						.trigger('click',{scroll:false})

			# Non-Compact
			else
				$docHeaders
					.addClass('hover-link')
					.click (event,opts) ->
						$docHeaders.filter('.current').removeClass('current')
						$header = $(this)
							.addClass('current')
							.stop(true,false).css({'opacity':0.5}).animate({opacity:1},1000)
						$header.ScrollTo()  if !opts or opts.scroll isnt false

		else
			$docHeaders = null

	# Load the user
	$.get '/user/', (data) ->
		$accountContent.html(data)

	# Always trigger initial page change
	$window.trigger('statechangecomplete')

	# Scroll Spy
	setInterval(
		->
			pageLeftToRead = document.height - (window.scrollY + window.innerHeight)
			$articleNav = $article.find('.prev-next a.next')
			if pageLeftToRead <= 50
				$articleNav.css('opacity',1)
			else
				$articleNav.removeAttr('style')
		500
	)