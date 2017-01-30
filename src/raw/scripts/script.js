/* eslint no-var:0 */
(function () {
	var body = document.body
	var modals = document.querySelectorAll('.modal')
	var modalBackdrop = document.querySelector('.modal.backdrop')
	var modalPayment = document.querySelector('.modal.payment')
	var googleAnalytics = window._gaq

	function hideModals (hash) {
		for (var i = 0; i < modals.length; ++i) {
			modals[i].style.display = 'none'
		}
		if ( hash ) {
			document.location.hash = 'ok'
		}
	}

	function documentKeyUp (event) {
		// 27 is escape key
		if ( modalBackdrop.style.display !== 'none' && event.keyCode === 27 ) {
			hideModals(true)
		}
	}

	function backdropClick (event) {
		event.stopImmediatePropagation()
		event.preventDefault()
		hideModals(true)
	}

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

		modalPayment.style.height = 'auto'
		modalBackdrop.style.height = window.innerHeight * 2 + 'px'

		modalPayment.style.opacity = 0
		modalPayment.style.display = 'block'

		var t = modalPayment.offsetTop
		var l = modalPayment.offsetLeft
		if ( modalPayment.clientHeight + t * 2 > window.innerHeight ) {
			modalPayment.style.top = l + 'px'
			modalPayment.style.maxHeight = window.innerHeight - l * 2 + 'px'
		}
		else {
			modalPayment.style.top = '5.5em'
		}

		modalBackdrop.style.display = 'block'
		modalPayment.style.opacity = 1
	}

	function showImages (nodes) {
		for (var i = 0; i < nodes.length; ++i) {
			nodes[i].src = nodes[i].getAttribute('data-src')
			nodes[i].removeAttribute('data-src')
		}
	}

	function windowHashChange () {
		var hash = document.location.hash.replace('#', '')
		hideModals()
		switch ( hash ) {
			case 'past':
				showImages(document.querySelectorAll('.past [data-src]'))
				body.className = body.className.replace(/today|future/, '') + ' past'
				break

			case 'today':
				showImages(document.querySelectorAll('.today [data-src]'))
				body.className = body.className.replace(/past|future/, '') + ' today'
				break

			case 'future':
				showImages(document.querySelectorAll('.future [data-src]'))
				body.className = body.className.replace(/past|today/, '') + ' future'
				break

			case 'payment':
				showPaymentModel()
				break

			default:
				// ignore
				break
		}
	}

	document.onkeyup = documentKeyUp
	modalBackdrop.onclick = backdropClick
	window.onhashchange = windowHashChange
	windowHashChange()
}())