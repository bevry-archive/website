ul '.contributors', ->
	for own contributorId,contributorData of @contributors or {}
		li '.contributor', ->
			span '.contributor-name', ->
				if contributorData.url
					a href:contributorData.url, title:'visit their github', ->
						contributorData.name
				else
					text contributorData.name
			span '.contributor-repos', ->
				text " contributed to: "
				for own key,value of contributorData.repos
					repoUrl = value
					if contributorData.username
						contributionUrl = "#{repoUrl}/commits?author=#{contributorData.username}"
						a '.contributor-repo', title:'view their contributions', href:contributionUrl, key
					else
						a '.contributor-repo', title:'visit the project', href:repoUrl, key