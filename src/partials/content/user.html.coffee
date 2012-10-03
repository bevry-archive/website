{user} = @

if user is false
	div '.loading', ->
		"loading"

else if user is null
	div '.login', ->
		a '.btn.no-ajaxy', href:'/auth/github', -> "Login with GitHub"

else
	div '.stuff', ->
		header ->
			if user.avatarUrl
				div ".avatar", ->
					img ".avatar-image", src:user.avatarUrl
			div ".name", ->
				text user.displayName
		div ->
			div ".well", ->
				text "la la la"

			text """
				<t render="markdown">
					## Subscriber
					Have you received value from Bevry? Here is your chance to give value back and fund the development, maintenance and documentation efforts of our open-source projects.

					## Priority Support
					Working on a critical application or hate wasting your time looking for answers yourself? Priority support gets you answers fast.

					## Hosting
					Don’t want to bother with all the hassles of hosting? Let us take care of it for you, we can deploy your DocPad website to the cloud for the world to access as quickly as possible.
				</t>
				"""