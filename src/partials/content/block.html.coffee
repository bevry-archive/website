# Prepare
{permalink,heading,subheading,content,className,prev,next,up} = @

# Render
article ".block"+(if className then ".#{className}" else ""), ->
	header ".block-header", ->
		if permalink
			a '.permalink.hover-link', href:permalink, ->
				h1 heading
		else
			h1 heading
		if subheading
			h2 subheading

	section ".block-content", content

	footer ".block-footer", ->
		if prev or up or next
			nav ".prev-next", ->
				if prev
					a ".prev", href:prev.url, ->
						span ".icon.icon-prev", ->
						span ".title", -> prev.title
				if up
					a '.up', href:up.url, ->
						span '.icon.icon-up', ->
						span '.title', -> up.title
				if next
					a ".next", href:next.url, ->
						span ".icon.icon-next", ->
						span ".title", -> next.title