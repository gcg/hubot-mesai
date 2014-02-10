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
  robot.hear /mesai|sıkıldım/i, (msg) ->
    now = new Date
    hoursLeft = new Number(Math.round(18 - now.getHours()))
    minutesLeft = Math.round(60 - now.getMinutes())

    if 0 < now.getDay() < 6
      resp = if hoursLeft > 0 then "You have "+hoursLeft+" hours and "+minutesLeft+" minutes left to go, hang in there" else "\\o/ no more work for today, go & have fun"	  
    else 
      resp = if now.getDay() == 6 then "Life is a beach, enjoy it" else "I can, but I won't"

    msg.send resp+" debug date:"+now