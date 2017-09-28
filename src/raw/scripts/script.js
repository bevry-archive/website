/* eslint-env browser */
/* eslint no-const:0 */
'use strict'

const body = document.body
const modals = document.querySelectorAll('.modal')
const modalBackdrop = document.querySelector('.modal.backdrop')
const modalPayment = document.querySelector('.modal.payment')
const googleAnalytics = window._gaq
const config = {
	pages: ['past', 'today', 'future']
}
const state = {
	page: 'today'
}

function hideModals () {
	for (let i = 0; i < modals.length; ++i) {
		modals[i].style.display = 'none'
	}
}

function documentKeyUp (event) {
	// 27 is escape key
	if (modalBackdrop.style.display !== 'none' && event.keyCode === 27) {
		document.location.hash = state.page
	}
}

function backdropClick (event) {
	event.stopImmediatePropagation()
	event.preventDefault()
	document.location.hash = state.page
}

function showPaymentModal () {
	if (googleAnalytics) {
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
	modalBackdrop.style.height = (window.innerHeight * 2) + 'px'

	modalPayment.style.opacity = 0
	modalPayment.style.display = 'block'

	const t = modalPayment.offsetTop
	const l = modalPayment.offsetLeft
	if (modalPayment.clientHeight + (t * 2) > window.innerHeight) {
		modalPayment.style.top = l + 'px'
		modalPayment.style.maxHeight = window.innerHeight - (l * 2) + 'px'
	}
	else {
		modalPayment.style.top = '5.5em'
	}

	modalBackdrop.style.display = 'block'
	modalPayment.style.opacity = 1
}

function showImages (nodes) {
	for (let i = 0; i < nodes.length; ++i) {
		nodes[i].src = nodes[i].getAttribute('data-src')
		nodes[i].removeAttribute('data-src')
	}
}

function windowHashChange () {
	const hash = document.location.hash.replace('#', '')
	if (!hash) {
		document.location.hash = state.page
		return
	}
	hideModals()
	if (hash === 'payment') {
		showPaymentModal()
	}
	else if (config.pages.indexOf(hash) !== -1) {
		showImages(document.querySelectorAll('.' + hash + ' [data-src]'))
		config.pages.forEach((page) => body.classList.remove(page))
		body.classList.add(hash)
		state.page = hash
	}
}

document.onkeyup = documentKeyUp
modalBackdrop.onclick = backdropClick
window.onhashchange = windowHashChange
windowHashChange()
