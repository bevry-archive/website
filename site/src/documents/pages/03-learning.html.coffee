###
title: Learning
layout: page
url: '/learn/'
standalone: true
###

# Prepare
_ = @underscore
docs = @docs
learnCollection = @getCollection('learn')
{getLabelName,getProjectName,getCategoryName} = @

# Prepare
section '.reference', ->

	# Projects
	nav ".projects", ->
		projects = _.uniq learnCollection.pluck('project')
		for project in  _.uniq learnCollection.pluck('project')
			pagesInProject = learnCollection.findAll({'project':project},{categoryDirectory:1})
			categoriesInProject = _.uniq pagesInProject.pluck('category')

			# Project
			li "##{project}.project.subblock", ->
				h2 -> getProjectName(project)

				# Categories
				columns = if categoriesInProject.length > 4 then 4 else categoriesInProject.length
				nav ".categories.columns-#{columns}", ->
					for projectCategory in categoriesInProject
						pagesInProjectCategory = pagesInProject.findAll({'category':projectCategory},[filename:1])

						# Category
						li "##{project}-#{projectCategory}.category", ->
							h3 -> getCategoryName(projectCategory)

							# Pages
							nav ".pages", ->
								pagesInProjectCategory.forEach (page) ->

									# Page
									li ".page", ->
										h4 '.title', ->
											a href:page.get('url'), -> page.get('title')
											label = page.get('label')
											if label
												span ".label.label-#{label}", -> getLabelName(label)


###
# Reference
h2 "Reference"
text @partial "content/subblock.html.coffee", {
	avatar: '/images/book.gif'
	heading: """
		<a href="/reference">Reference Manual</a>
		"""
	#subheading: "Stackoverflow owns &amp; manages, Bevry participates"
	content: """
		<t render="markdown">
		The official and comprehensive **man pages** that are included in the Git package itself.
		</t>
		"""
}
text """
	<t render="markdown">
	Quick Reference guides:
	[Heroku Cheat Sheet](/) (PDF)
	</t>
	"""


# Videos
h2 "Videos"
###
