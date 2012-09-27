---
title: Learning
layout: page
---

# Prepare
_ = @underscore
docs = @docs
learnCollection = @getCollection('learn')


# Reference
projects = _.uniq learnCollection.pluck('project')
for project in  _.uniq learnCollection.pluck('project')
	projectPagesCollection = learnCollection.findAll('project':project)
	projectCategories = _.uniq projectPagesCollection.pluck('category')

	nav ".project-"+project, ->
		h2 -> text "<t>text.project#{project}</t>"
		section '.reference', ->
			ul ->

				for projectCategory in projectCategories
					projectCategoryPagesCollection = projectPagesCollection.findAll({'category':projectCategory},[filename:1])

					li ->
						h3 -> text "<t>text.category#{projectCategory}</t>"
						ul ->
							projectCategoryPagesCollection.forEach (page) ->
								li ->
									h4 '.title', page.get('name')


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


# Reference
h2 "Reference"
section '.reference', ->
	ul ->
		for own chapter,contents of docs['Reference']
			li ->
				span '.title', chapter
				if contents
					ul ->
						for own _chapter,_contents of contents
							li ->
								span '.title', _chapter

# Guides
h2 "Guides"
section '.guides', ->
	ul ->
		for own chapter,contents of docs['Guides']
			li ->
				span '.title', chapter
				if contents
					ol ->
						for own _chapter,_contents of contents
							li ->
								span '.title', _chapter

# Book
h2 "Book"
section '.book', ->

	bookChapters = """
		Getting Started
		Git Basics
		Git Branching
		Git on the Server
		Distributed GitGit Tools
		Customizing GitGit and Other Systems
		Git Internals
		Index of Commands
		""".split /\s*\n\s*/
	ol ->
		li bookChapter  for bookChapter in bookChapters

	footer '.footnote', ->
		"""
		Book information and downloads
		"""


# Videos
h2 "Videos"
