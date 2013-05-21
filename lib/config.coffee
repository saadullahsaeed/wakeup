fs = require 'fs'

class Config
	load: (path)->
		data = fs.readFileSync path, 'utf-8'
		@config = JSON.parse data
		console.log @config
		@
		
	get: (name)-> @config[name]
	
	getAccount: ()-> @get 'account'
	getWakeup: ()-> @get 'wakeup'

module.exports = new Config