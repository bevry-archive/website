# Prepare
{heading,subheading,content,className} = @

# Render
article ".block"+(if className then ".#{className}" else ""), ->
	header ".block-header", ->
		h1 heading
		if subheading
			h2 subheading
	section ".block-content", content