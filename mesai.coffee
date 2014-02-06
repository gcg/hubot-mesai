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

resp = ""

now = new Date

isItWorkDay = if now.getDay() < 6 then true else false

alert(isItWorkDay)

hoursLeft = Math.round(18 - now.getHours())
minutesLeft = Math.round(60 - now.getMinutes())

if isItWorkDay
  if hoursLeft < 1 and minutesLeft < 1
    resp = "\o/ no more work for today, go & have fun"
  else 
    resp = "You have "+hoursLeft+" hours and "+minutesLeft+" minutes left to go, hang in there"   
  
else 
 resp = if now.getDay() == 6 then "Life is a beach, enjoy it" else "I can, but I won't"

module.exports = (robot) ->
  robot.hear /mesai/i, (msg) ->
    msg.send resp