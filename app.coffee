express = require('express')
Config = require('./lib/config').load('./config/config.json')
Caller = require('./lib/caller')
Waker = require('./lib/waker')

wakeupIntervalHandler = 0
awakeIntervalHandler = 0


Caller = new Caller(Config.getAccount())
Caller.init()

Waker = new Waker(Config.getWakeup())


setWakeupInterval = ()-> wakeupIntervalHandler = setInterval wakeUpHandler, 5000
clearWakeupInterval = ()-> clearInterval wakeupIntervalHandler

setAwakeInterval = ()-> awakeIntervalHandler = setInterval redialHandler, 1000 * 60 * 1
clearAwakeInterval = ()-> clearInterval awakeIntervalHandler


#Wakeup Handler
wakeUpHandler = ()=> 
	if Waker.isTime()
		problem = Waker.generateProblem()
		problem_text = "Problem is: #{problem[0]} plus #{problem[1]}. I repeat its #{problem[0]} plus #{problem[1]}"
		console.log problem_text
		Caller.makeCall Waker.getNumber(), problem_text
		setAwakeInterval()
		clearWakeupInterval()

		
#Redial Handler
redialHandler = ()=>
	if Waker.isUpYet() or Waker.shouldStopAlarm()
		clearAwakeInterval()
		setWakeupInterval()
		console.log "stopping interval. User is up "
	else
		Caller.redial()


#Set the wakeup interval
setWakeupInterval()

#Start Accepting Calls
app = express()
app.get '/awake', (req, res)=>
	answer = req.query['answer']
	console.log "submitting solution #{answer}"
	Waker.submitSolution(answer)
	body = 'OK'
	res.setHeader 'Content-Type', 'text/plain'
	res.setHeader 'Content-Length', body.length
	res.end body

app.listen(3000)
