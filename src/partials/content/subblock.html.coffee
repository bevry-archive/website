# Prepare
{avatar,heading,subheading,content} = @

# Render
section ".subblock", ->
	div ".subblock-avatar", ->
		img ".subblock-avatar-image", "src": avatar
	header ".subblock-header", ->
		h1 heading
		h2 subheading
	section ".subblock-content", content