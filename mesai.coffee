# Description
#   Just a simple script to track how much time left for work day to end. 
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   <mesai> - <gives HH:MM response to how much time left for the work day to end>
#
# Notes:
#   None
#
# Author:
#   @gcg



module.exports = (robot) ->
	resp = ""

	now = new Date

	isItWorkDay = 0 < now.getDay() < 6

	hoursLeft = new Number(Math.round(18 - now.getHours()))
	minutesLeft = Math.round(60 - now.getMinutes())

	stillMesai = hoursLeft > 0

	if isItWorkDay
		resp = if stillMesai then "You have "+hoursLeft+" hours and "+minutesLeft+" minutes left to go, hang in there" else "\\o/ no more work for today, go & have fun"
	  
	else 
	 resp = if now.getDay() == 6 then "Life is a beach, enjoy it" else "I can, but I won't"
	
  robot.hear /mesai|sıkıldım/i, (msg) ->
    msg.send resp
  robot.respond /debugtime/i, (msg) ->
  	msg.send "Time ise: " + now + "hoursLeft: "+hoursLeft+" minutesLeft: "+minutesLeft + "Response is: "+ resp