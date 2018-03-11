'use strict'

// Prepare
const githubClientId = process.env.GITHUB_CLIENT_ID
const githubClientSecret = process.env.GITHUB_CLIENT_SECRET
const githubAuthString = `client_id=${githubClientId}&client_secret=${githubClientSecret}`
const githubNames = 'bevry docpad browserstate webwrite interconnectapp'.split(' ')
const feeds = (function () {
	/* eslint camelcase:0 */
	const result = {}
	githubNames.forEach(function (name) {
		result['github_members_' + name] = {
			url: `https://api.github.com/orgs/${name}/public_members?${githubAuthString}`,
			parse: 'json'
		}
	})
	return result
}())


// The DocPad Configuration File
// It is simply a CoffeeScript Object which is parsed by CSON
const docpadConfig = {

	// =================================
	// Template Data
	// These are variables that will be accessible via our templates
	// To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData: {

		getGratipayTotal () {
			return 0
		},

		getDonationTotal () {
			return this.getGratipayTotal() * (52 / 12)
		},

		getDonationGoal () {
			return 4000
		},

		getDonationGoalPercent (goal) {
			if (goal == null) goal = this.getDonationGoal()
			return (this.getDonationTotal() / goal) * 100
		},

		isDonationEnough () {
			return this.getDonationGoalPercent() >= 100
		},

		getGithubMembers () {
			const feedr = this.feedr
			const logins = {}

			githubNames.forEach(function (name) {
				feedr.feeds['github_members_' + name].forEach(function (member) {
					logins[member.login] = {
						name: member.login,
						avatar: member.avatar_url,
						url: member.html_url
					}
				})
			})

			// remove leaders from members as it's a bit dodgy if we list them twice
			this.leaders.forEach(function (leader) {
				if (leader.githubUsername) {
					delete logins[leader.githubUsername]
				}
			})

			const members = []
			for (const key in logins) {
				if (logins.hasOwnProperty(key)) {
					const value = logins[key]
					members.push(value)
				}
			}

			return members
		},

		/* eslint key-spacing:0 */
		banks: {
			'USD Transfers': {
				'Account Name': 'Benjamin Arthur Lupton',
				'Account Number': '8310013710',
				'ACH Routing Number': '026073150',
				'Wire Routing Number': '026073008',
				'Bank Name': 'COMMUNITY FEDERAL SAVINGS BANK',
				'Branch Address': 'TransferWise, 19 W 24th Street, New York, 10010, United States of America'
			},
			'EUR Transfers': {
				'Account Name': 'TW Benjamin Arthur Lupton',
				'IBAN': 'DE03 7001 1110 6050 3324 28',
				'BIC/Swift Code': 'DEKTDE7GXXX',
				'Branch Address': 'Deutsche Handelsbank, Südliche Münchner Str. 2, Grünwald, 82031, Deutschland'
			},
			'GBP Transfers': {
				'Account Name': 'Benjamin Arthur Lupton',
				'Account Number': '19295940',
				'UK Sort Code': '23-14-70',
				'Branch Address': 'TransferWise, 56 Shoreditch High Street, London, E1 6JJ, United Kingdom'
			},
			'AUD Transfers': {
				'Account Name': 'Benjamin Arthur Lupton',
				'Account Number': '454000526',
				'BSB': '082-182',
				'Bank Name': 'National Australia Bank Limited (NAB)',
				'Branch Address': 'TransferWise, 800 Bourke Street, Melbourne, 3000, Australia'
			}
		},

		leaders: [{
			name: 'Benjamin Lupton',
			title: 'Benjamin Lupton, Founder',
			githubUsername: 'balupton',
			url: 'http://balupton.com',
			avatar: '/images/ben-black.jpg',
			description: `
				<span class="today future">
					Open-Collaboration Entrepreneur. International Speaker & Trainer.
				</span>
				<span class="past">
					Bevry is the result of Benjamin's best self, a tool for him and others to create and collaborate on a shared vision of a better world. His works are at the foundations of Bevry and are some of the most popular node and javascript projects, even used by the likes of Microsoft and 37Signals. Besides work, he pursues the timeless quest of understanding the world and spends time with his family.
				</span>`
		}, {
			name: 'Michael Duane Mooring',
			className: 'today future',
			title: 'Mike Mooring, Community Custodian',
			githubUsername: 'mikeumus',
			url: 'https://twitter.com/mikeumus',
			avatar: '/images/mikeumus-tinted.jpg',
			description: `
				<a href="https://newspace.nyc/">Private Space Entrepreneur</a>. Founder at <a href="https://mdm.cc/">Mass Distribution Media</a>.<br/>
				Sees technology as a force of nature for good.`
		}],

		sponsors: [],

		pastSponsors: [{
			name: 'Myplanet',
			className: 'today',
			url: 'http://myplanet.io'
		}, {
			name: 'Meeho!',
			className: 'today',
			url: 'http://meeho.net'
		}, {
			name: 'Hybris',
			className: 'today',
			url: 'http://hybris.co'
		}, {
			name: 'Meltmedia',
			className: 'today',
			url: 'http://meltmedia.com/'
		}].sort((a, b) => a.name - b.name),

		projects: [{
			name: 'DocPad',
			url: 'http://docpad.org',
			description: 'Powerful Static Site Generator<br/>500 daily users'
		}, {
			name: 'History.js',
			url: 'https://github.com/browserstate',
			description: 'Create Stateful Web-Applications<br/>Used in <a href="http://basecamp.com" title="Visit Basecamp\'s Website">Basecamp</a>'
		}, {
			name: 'Startup Hostel Network',
			className: 'today future',
			url: 'http://startuphostel.org',
			description: 'Co-work and co-live while you travel the world<br/>176 travellers'
		}, {
			name: 'Static Site Generators',
			className: 'today future',
			url: 'http://staticsitegenerators.net',
			description: 'Discover the right Static Site Generator for you<br/>400 static site generators'
		}, {
			name: 'Chainy (beta)',
			className: 'today future',
			url: 'https://github.com/chainyjs',
			description: 'Chainable data pipeline for JavaScript'
		}, {
			name: 'Interconnect (alpha)',
			className: 'today future',
			url: 'https://github.com/interconnectapp',
			description: 'Connect with anyone in the world'
		}, {
			name: 'Web Write (alpha)',
			className: 'today future',
			url: 'https://github.com/webwrite',
			description: 'Admin Interfaces for any backend'
		}],

		// Specify some site properties
		site: {
			// The production url of our website
			url: 'https://bevry.me',

			// The default title of our website
			title: 'Bevry',

			// The website description (for SEO)
			description: 'An open company and community dedicated to empowering developers everywhere.',

			// The website keywords (for SEO) separated by commas
			keywords: 'bevry, bevryme, balupton, benjamin lupton, docpad, history.js, node.js, javascript, coffee-script, query-engine, open-source, open-collaboration, open-company, free-culture',

			// The website's styles
			styles: [
				'/vendor/normalize.css',
				'/vendor/h5bp.css',
				'/styles/style.css'
			],

			// The website's scripts
			scripts: [
				'/scripts/script.js'
			]
		},


		// -----------------------------
		// Helper Functions

		// Get the prepared site/document title
		// Often we would like to specify particular formatting to our page's title
		// we can apply that formatting here
		getPreparedTitle () {
			// if we have a document title, then we should use that and suffix the site's title onto it
			if (this.document.title) {
				return `${this.document.title} | ${this.site.title}`
			}

			// if our document does not have it's own title, then we should just use the site's title
			else {
				return this.site.title
			}
		},

		// Get the prepared site/document description
		getPreparedDescription () {
			// if we have a document description, then we should use that, otherwise use the site's description
			return this.document.description || this.site.description
		},

		// Get the prepared site/document keywords
		getPreparedKeywords () {
			// Merge the document keywords with the site keywords
			return this.site.keywords.concat(this.document.keywords || []).join(', ')
		},

		// Get Full URL
		getFullUrl (shortUrl) {
			return docpadConfig.plugins.cleanurls.simpleRedirects[shortUrl] || shortUrl
		}
	},

	plugins: {
		feedr: { feeds },

		cleanurls: {

			simpleRedirects: {
				// Shorthands
				'/contact': '/#contact',
				'/terms': '/tos/',
				'/donate': '/#donate',
				'/source': 'https://github.com/bevry/website',

				// Payment
				'/payment': '/#payment',
				'/goopen': 'https://github.com/bevry/goopen',
				'/bitcoin': 'https://coinbase.com/checkouts/9ef59f5479eec1d97d63382c9ebcb93a?r=516032d5fc3baa863b000010',
				'/coinbase': '/bitcoin',
				'/paypal': 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6',
				'/flattr': 'https://flattr.com/profile/balupton',
				'/patreon': 'https://www.patreon.com/bevry',
				'/opencollective': 'https://opencollective.com/bevry',
				'/gratipay': 'https://gratipay.news/the-end-cbfba8f50981',
				'/liberapay': 'https://liberapay.com/bevry',
				'/cash': '/bitcoin',
				'/gittip': '/gratipay',
				'/wishlist': 'https://balupton.com/wishlist',  // here for legacy reasons as github badges still use it

				// Social
				'/google+': 'https://plus.google.com/+BevryMe',
				'/twitter': 'https://discuss.bevry.me/t/official-twitter-accounts/86',
				'/youtube': 'https://www.youtube.com/channel/UC0HLq-UQ49GA43aHbxJlXNg',
				'/trello': 'https://trello.com/b/z62c2a6Z/bevry-focus',
				'/blog': 'https://blog.bevry.me',

				// Support
				'/slack': 'https://slack.bevry.me',
				'/forum': 'https://discuss.bevry.me',
				'/support': 'https://discuss.bevry.me/t/getting-support-guide/63/1',
				'/contribute': 'https://discuss.bevry.me/t/official-contribution-guide/141/1',
				'/premium-support': '/support',

				// Documentation
				'/node/install': 'https://learn.bevry.me/node/install',
				'/docs/installnode': '/node/install',

				// Training Resources
				'/nodefailsafe': 'https://gist.github.com/balupton/4721905fe5d51c541660',
				'/talks/handsonnode': 'http://node.eventbrite.com/',
				'/node.zip': 'https://www.dropbox.com/s/masz4vl1b4btwfw/hands-on-node-examples.zip'
			},

			advancedRedirects: [
				// Old URLs
				[/^https?:\/\/(?:refresh\.bevry\.me|bevry\.herokuapp\.com|bevry\.github\.io\/website)(.*)$/, 'https://bevry.me$1'],

				// Documentation Projects
				[/^\/(docpad|node|queryengine|joe|taskgroup|community|bevry)(?:[/-](.*))?$/, 'http://learn.bevry.me/$1/$2'],

				// Documentation
				[/^\/learn(?:\/(.*))$/, 'http://learn.bevry.me/$1'],

				// Old Pages
				[/^\/(services|projects|about)\/?$/, '/#$1'],

				// Projects
				[/^\/(?:g|gh|github|project)(?:\/(.*))?$/, 'https://github.com/bevry/$1']
			]
		}
	}
}

// Export our DocPad Configuration
module.exports = docpadConfig
