# Prepare
{permalink,heading,subheading,content,className,prev,next} = @

# Render
article ".block"+(if className then ".#{className}" else ""), ->
	header ".block-header", ->
		a '.up', href:'../', ->
			span '.icon-up', ->
			span '.title', -> 'DocPad'
		if permalink
			a '.permalink.hover-link', href:permalink, ->
				h1 heading
		else
			h1 heading
		if subheading
			h2 subheading

	section ".block-content", content

	footer ".block-footer", ->
		if prev or next
			nav ".prev-next", ->
				if prev
					a ".prev", href:"/prev", ->
						span ".icon-prev", ->
						span ".title", -> prev
				if next
					a ".next", href:"/next", ->
						span ".icon-next", ->
						span ".title", -> next