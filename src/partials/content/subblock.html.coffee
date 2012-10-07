# Prepare
{avatar,heading,subheading,content} = @

# Render
section ".subblock"+(if avatar then ".subblock-yesavatar" else ".subblock-noavatar"), ->
	if avatar
		div ".avatar", ->
			img ".avatar-image", "src": avatar
	div '.main', ->
		header ".heading", ->
			h1 heading
			h2 subheading
		section ".content", content