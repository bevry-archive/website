# Prepare
{avatar,heading,subheading,content} = @

# Render
section ".subblock"+(if avatar then ".subblock-yesavatar" else ".subblock-noavatar"), ->
	if avatar
		div ".subblock-avatar", ->
			img ".subblock-avatar-image", "src": avatar
	div ".subblock-main", ->
		header ".subblock-header", ->
			h1 heading
			h2 subheading
		section ".subblock-content", content