ul '.contributors', ->
	for own contributorId,contributorData of @contributors or {}
		li '.contributor', ->
			if contributorData.url
				a href:contributorData.url, ->
					contributorData.name
			else
				text contributorData.name
