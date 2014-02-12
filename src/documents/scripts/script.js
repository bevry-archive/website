/* Your scripts go here */
(function(){
	var $body = $(document.body);
	$('nav.years a').click(function(event){
		event.preventDefault();
		switch ( this.className ) {
			case 'past-link':
				$body.removeClass('today future').addClass('past');
				break;

			case 'today-link':
				$body.removeClass('past future').addClass('today');
				break;

			case 'future-link':
				$body.removeClass('past today').addClass('future');
				break;
		}
		/*
		$body.addClass('diff');
		setTimeout(function(){
			$body.removeClass('diff');
		},1000);
		*/
	});
	/*
	$(window).scroll(function(){
		if ( window.scrollY > 209 ) {
			$body.addClass('scrolled');
		}
		else {
			$body.removeClass('scrolled');
		}
	});
	*/
})();