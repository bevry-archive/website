for testimonial in @testimonials
	blockquote ->
		em style:"color: hsl(121, 100%, 20%)", ->
			text "&ldquo;#{testimonial.text}&rdquo;"
		br()
		span style:"font-size: 0.9em", ->
			a href:testimonial.authorLink, ->
				testimonial.author
			text ' - '
			text testimonial.job
			text ' at '
			if testimonial.companyLink
				a href:testimonial.companyLink, ->
					text testimonial.company
			else
				text testimonial.company
			text ' - '
			text testimonial.time