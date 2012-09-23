# Prepare
{heading,subheading,content} = @

# Render
article ".block", ->
	header ".block-header", ->
		h1 heading
		if subheading
			h2 subheading
	section ".block-content", content