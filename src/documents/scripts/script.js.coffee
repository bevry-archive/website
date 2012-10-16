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
		hostname = url.replace(/^.+\/|\/.*/g,'')
		_gaq.push(['_trackEvent', "Outbound Links", hostname, url, 0, true])
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

		if $article.is('.block.doc:not(.no-compact)')
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