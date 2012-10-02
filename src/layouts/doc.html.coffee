###
layout: structure
###

learnCollection = @getCollection('learn')
for item,index in learnCollection.models
	if item.id is @document.id
		break
prevModel = learnCollection.models[index-1] ? null
nextModel = learnCollection.models[index+1] ? null
prevModel = null  if prevModel and prevModel.attributes.project isnt @document.project
nextModel = null  if nextModel and nextModel.attributes.project isnt @document.project

text @partial('content/block.html.coffee',{
	className: ".doc"
	permalink: @document.url
	heading: @document.title
	subheading: @document.subheading
	content: @content
	prev:
		if prevModel
			url: prevModel.attributes.url
			title: prevModel.attributes.title
	next:
		if nextModel
			url: nextModel.attributes.url
			title: nextModel.attributes.title
	up:
		url: "/learn/"
		title: @document.projectName
})