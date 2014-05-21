$window = $(window)
$document = $(document)
$body = $(document.body)
$modalBackdrop = $('.modal.backdrop')

# Modals
hideModals = (hash) ->
	$('.modal').hide()
	document.location.hash = ''  if hash

$document.on 'keyup', (event) ->
	if $modalBackdrop.is(':visible') and event.keyCode is 27  # escape
		hideModals(true)

$modalBackdrop.on 'click', (event) ->
	event.stopImmediatePropagation()
	event.preventDefault()
	hideModals(true)

showPaymentModel = ->
	_gaq?.push(['_trackEvent', "Payment Modal", document.title, document.location.href, 0, true])

	$modal = $('.payment.modal').css({
		top: '5.5em'
		height: 'auto'
		opacity: 0
	}).show()
	$modalBackdrop = $('.modal.backdrop').css({
		height: window.innerHeight*2
	})

	modalOffset = $modal.offset()
	if $modal.height()+modalOffset.top*2 > window.innerHeight
		$modal.css({
			top: modalOffset.left
			height: window.innerHeight-modalOffset.left*2
		})

	$modalBackdrop.show()
	$modal.css({
		opacity: 1
	})

$window.on 'hashchange', ->
	hash = document.location.hash.replace('#', '')

	switch hash
		when 'past'
			$body.removeClass('today future').addClass('past')

		when 'today'
			$body.removeClass('past future').addClass('today')

		when 'future'
			$body.removeClass('past today').addClass('future')

	if hash is 'payment'
		showPaymentModel()
	else
		hideModals()

$window.trigger('hashchange')

`
var handler = StripeCheckout.configure({
	key: 'pk_YaaQsFv9x6P6jli6WwGLwQ4wr0971',
	token: function(token, args) {
		// Use the token to create the charge with a server-side script.
		// You can access the token ID with token.id
	}
});

document.getElementById('stripe_payment_button').addEventListener('click', function(e) {
	e.preventDefault();
	var amount = prompt('In Australian Dollars, how much would you like to donate?');
	amount = String(amount).replace(/\..*$/, '').replace(/[^0-9]/g, '');
	amount = parseInt(amount, 10);
	if ( amount && !isNaN(amount) ) {
		// Open Checkout with further options
		handler.open({
			name: 'Donation to Bevry',
			description: 'Support our open-source initiatives',
			amount: amount*100
		});
	}
});
`
