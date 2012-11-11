{partial} = @

text partial('content/subblock.html.coffee', {
	cssClasses: ['purchase-booking']
	heading: "Make a Booking"
	content: """
		<label>
			Booking Type:
			<select>
				<option>Support</option>
				<option>Training</option>
				<option>Development</option>
				<option>Advisory</option>
			</select>
		</label>

		<br/>
		<label>
			Time Required:
			<input type="number"
				min="0.5"
				step="0.5"
				value="0.5" />
			hours
		</label>

		<br/>
		<label>
			Time Required:
			<select class="timereq">
				<option>0.5</option>
				<option>1</option>
				<option>1.5</option>
				<option>2</option>
				<option>2.5</option>
				<option>3</option>
				<option>4</option>
				<option>5</option>
				<option>more</option>
			</select>
			<input class="timereq2" type="number"
				min="0.5"
				step="0.5"
				value="0.5" />
			hours
		</label>

		<br/>
		<label>
			<input type="checkbox" /> Repeat this booking every month?
		<label>

		<form action="https://www.paypal.com/cgi-bin/webscr" method="post">
			<input type="hidden" name="cmd" value="_xclick">
			<input type="hidden" name="business" value="FEMAUCHZ39YZJ">
			<input type="hidden" name="lc" value="AU">
			<input type="hidden" name="item_name" value="Bevry Premium Service">
			<input type="hidden" name="amount" value="150.00">
			<input type="hidden" name="currency_code" value="AUD">
			<input type="hidden" name="button_subtype" value="services">
			<input type="hidden" name="no_note" value="1">
			<input type="hidden" name="no_shipping" value="1">
			<input type="hidden" name="undefined_quantity" value="1">
			<input type="hidden" name="rm" value="1">
			<input type="hidden" name="return" value="https://bevry.me/purchase?success">
			<input type="hidden" name="cancel_return" value="https://bevry.me/purchase?cancel">
			<input type="hidden" name="bn" value="PP-BuyNowBF:btn_buynowCC_LG.gif:NonHosted">
			<input type="image" src="https://www.paypalobjects.com/en_AU/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal — The safer, easier way to pay online.">
			<img alt="" border="0" src="https://www.paypalobjects.com/en_AU/i/scr/pixel.gif" width="1" height="1">
		</form>
		"""
})