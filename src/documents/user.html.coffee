---
dynamic: true
url: '/user/'
---

text @partial('content/user.html.coffee', {
	user: @req.user or null
})