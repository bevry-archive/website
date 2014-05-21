$window = $(window)
$document = $(document)
$body = $(document.body)
$('nav.years a').click (event) ->
	event.preventDefault()
	switch @className
		when 'past-link'
			$body.removeClass('today future').addClass('past')

		when 'today-link'
			$body.removeClass('past future').addClass('today')

		when 'future-link'
			$body.removeClass('past today').addClass('future')

# Modals
hideModals = ->
	$('.modal').hide()
	document.location.hash = ''

$document.on 'keyup', (event) ->
	hideModals()  if event.keyCode is 27  # escape

$body.on 'click', '.modal.backdrop', (event) ->
	event.stopImmediatePropagation()
	event.preventDefault()
	hideModals()

showPaymentModel = ->
	_gaq?.push(['_trackEvent', "Payment Modal", document.title, document.location.href, 0, true])

	$modal = $('.payment.modal').css({
		top: '5.5em'
		height: 'auto'
		opacity: 0
	}).show()
	$backdropModal = $('.modal.backdrop').css({
		height: window.innerHeight*2
	})

	modalOffset = $modal.offset()
	if $modal.height()+modalOffset.top*2 > window.innerHeight
		$modal.css({
			top: modalOffset.left
			height: window.innerHeight-modalOffset.left*2
		})

	$backdropModal.show()
	$modal.css({
		opacity: 1
	})

$window.on 'hashchange', ->
	if document.location.hash.indexOf('payment') isnt -1
		showPaymentModel()
	else
		hideModals()
$window.trigger('hashchange')
