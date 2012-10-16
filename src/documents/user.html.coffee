---
dynamic: true
url: '/user/'
sitemap: false
---

text @partial('content/user.html.coffee', {
	user: @req.user or null
})