---
title: Projects
layout: page
url: '/projects/'
standalone: true
---

{getLinkName,projects} = @

# Prepare
section '.projects', ->
	nav '.projects', ->
		for own key,project of projects
			li "##{key}.project.subblock", ->
				div '.main', ->
					header '.heading', ->
						h1 -> a '.hover-link', href:project.links.main, -> project.title
					div '.content', -> project.content
					footer ->
						nav '.links', ->
							for own linkName,linkUrl of project.links
								li -> a '.btn', href:linkUrl, -> getLinkName(linkName)