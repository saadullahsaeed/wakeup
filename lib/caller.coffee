twilio = require('twilio')

class Caller
	constructor: (account)-> @account = account

	init: ()-> @client = twilio @account['sid'], @account['token']

	getCallURL: (message)->
		twiml = encodeURIComponent "<Response><Say>#{message}</Say></Response>"
		console.log twiml
		"http://twimlets.com/echo?Twiml=#{twiml}"

	makeMessage: (to, message_text)->
		call_message = 
			to: to
			from: @account['from_number']
			url: @getCallURL message_text
		call_message

	makeCall: (to, message_text)-> 
		console.log "makeCall"
		@setLastMessage to, message_text
		@client.makeCall @makeMessage(to, message_text), (err, responseData)=>

	setLastMessage: (to, message_text)-> 
		@last_number = to
		@last_message = message_text

	redial: ()-> 
		console.log "Redialing ..."
		@makeCall @last_number, @last_message 

module.exports = Caller