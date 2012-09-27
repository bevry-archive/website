docStr = """
- Reference
	- DocPad Architecture
		- Structure
		- Loader
		- Binaries
		- Core
		- Configuration
			- Files
			- Variables
			- Environments
		- Actions
			- Run
			- Generate
				- Parsing
				- Rendering
				- Writing
			- Server
				- Setup
				- Events
				- Dynamic Documents
			- Watching
		- Models
			- File
			- Document
		- Collections
			- Files
			- Documents
			- QueryEngine
		- Blocks
			- Meta
			- Scripts
			- Styles
		- Events
		- Plugins
		- Caching

	- DocPad Overview
		- Directories
		- Templates
			- Meta data
			- Template data
			- Template helpers
		- Querying
		- Generation
			- Markups
			- Extensions
		- Binaries
		- Loader
		- Initialisation
		- Generation
			- Meta Data
			- Extensions
			- Caching
		- Server
		- Watching

	- DocPad CLI
		- Commands
			- run
			- generate
			- watch
			- server
		- Configuration
			- Options
			- Environment
		- Prompts

- Guides
	- Getting Started
		- Installation
		- Quickstart
	- Beginner Guide
		- Creating the Standard Directories
		- Hello World
			- Create a document
			- Hit redundancy when we want more
		- Plugins
			- Install the live reload plugin
			- Quick rundown of plugins
		- Adding a stylesheet
			- Create the stylesheet
			- Problems with plain CSS
			- Using Stylus (intro to pre-processors)
		- Adding an image
			- Introduction to the files directory
			- Adding the image to files
			- Adding the image to our markup
			- How the directories work together
		- Adding a layout
			- Benefits of a layout (in relation to our posts)
			- Create the layout file
			- Take out the layout from our document
			- Introduction to meta data
			- Introduction to eco
		- Adding our posts
			- Create the directory
			- Add our posts with layout
			- Make them markdown
		- Nested layouts
			- Different layout for the posts
			- How do nested layouts work
		- Listing our posts
			- Introduction to collections and models
			- Introduction to querying, sorting
		- Further abstractions
			- Configuration files introduction
			- Template data variables
			- Template helpers
			- Collections
		- Deployment
			- Generate for static server
			- Different environments
			- Deploy to apache demonstration
		- All done
"""

docs = {}

extractList = (str,insert) ->
	insert ?= {}
	sections = str.split(/^-/m)
	for section in sections
		section = section.trim()
		continue  unless section
		split = section.indexOf('\n')
		if split is -1
			header = section
			insert[header] = null
		else
			header = section.substr(0,split).trim()
			body = section.substr(split).trim().replace(/^\t/gm,'').trim()
			insert[header] = extractList(body)
	return insert

module.exports = extractList(docStr,docs)