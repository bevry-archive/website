/* Your scripts go here */
(function(){
	$('nav.years a').click(function(event){
		event.preventDefault();
		switch ( this.className ) {
			case 'past-link':
				document.body.className = 'past';
				break;

			case 'today-link':
				document.body.className = 'today';
				break;

			case 'future-link':
				document.body.className = 'future';
				break;
		}
	});
})();