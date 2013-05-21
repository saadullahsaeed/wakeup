moment = require 'moment'

class Waker
	constructor: (config)->  @config = config

	shouldStopAlarm: ()-> @currentTime() is @stop_alarm_at
	shouldWakeupNow: ()->
		if @isTime()
			@stop_alarm_at = @getStopTime()
			@goToSleep()
			return yes
		return no


	isTime: ()-> @shouldWakeupToday() and @currentTime() is @config['time']
	currentTime: ()-> moment().format 'HH:mm'
	getStopTime: ()-> moment().add('minutes', 30).format("HH:mm")
	today: ()-> moment().format "dddd"
	shouldWakeupToday: ()-> @config['exclude'].indexOf(@today()) < 0

	getNumber: ()-> @config['number']

	generateProblem: ()-> 
		@op_a = @getRandom()
		@op_b = @getRandom()
		@correct_answer = @op_a + @op_b
		[@op_a, @op_b]

	getRandom: ()-> Math.round(Math.random() * 100)

	isCorrectAnswer: (answer)-> answer is @correct_answer
	submitSolution: (solution)-> @userIsUp() if @isCorrectAnswer parseInt(solution)

	goToSleep: ()-> @is_up = no
	userIsUp: ()-> @is_up = yes
	isUpYet: ()-> @is_up


module.exports = Waker