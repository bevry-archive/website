###
standalone: true
uglify: true
###

# App
class App extends BevryApp
	onDomReady: =>
		# Sidebar initial fadeout
		$sidebar = $('.sidebar')
		$sidebar.animate({opacity:0.5},3000).hover(
			->
				$sidebar.stop(true,false).animate({opacity:1},500)
			->
				$sidebar.stop(true,false).animate({opacity:0.5},2000)
		)

		# Super
		super

# Export
@App = App

# Create
app = new App()