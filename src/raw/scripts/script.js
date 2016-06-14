(function () {
	var $ = window.jQuery
	var $window = $(window)
	var $document = $(document)
	var $body = $(document.body)
	var $modalBackdrop = $('.modal.backdrop')
	var $modalPayment = $('.payment.modal')
	var googleAnalytics = window._gaq

	// Modals
	function hideModals (hash) {
		$('.modal').hide()
		if ( hash ) {
			document.location.hash = ''
		}
	}

	$document.on('keyup', function (event) {
		// 27 is escape key
		if ( $modalBackdrop.is(':visible') && event.keyCode === 27 ) {
			hideModals(true)
		}
	})

	$modalBackdrop.on('click', function (event) {
		event.stopImmediatePropagation()
		event.preventDefault()
		hideModals(true)
	})

	// bank details
	function showPaymentModel () {
		if ( googleAnalytics ) {
			googleAnalytics.push([
				'_trackEvent',
				'Payment Modal',
				document.title,
				document.location.href,
				0,
				true
			])
		}

		$modalPayment.css({
			top: '5.5em',
			height: 'auto',
			opacity: 0
		}).show()

		$modalBackdrop.css({
			height: window.innerHeight * 2
		})

		var modalOffset = $modalPayment.offset()
		if ( $modalPayment.height() + modalOffset.top * 2 > window.innerHeight ) {
			$modalPayment.css({
				top: modalOffset.left,
				maxHeight: window.innerHeight - modalOffset.left * 2
			})
		}

		$modalBackdrop.show()
		$modalPayment.css({
			opacity: 1
		})
	}

	$window.on('hashchange', function () {
		var hash = document.location.hash.replace('#', '')
		hideModals()
		switch ( hash ) {
			case 'past':
				$body.removeClass('today future').addClass('past')
				break

			case 'today':
				$body.removeClass('past future').addClass('today')
				break

			case 'future':
				$body.removeClass('past today').addClass('future')
				break

			case 'payment':
				showPaymentModel()
				break

			default:
				// ignore
				break
		}
		$window.trigger('hashchange')
	})
}())
