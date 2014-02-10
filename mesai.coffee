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

hafiza = {}

remember = (msg, username, days, endofshift) ->
  data = {}
  hafiza[username.toLowerCase()] ?= {}
  hafiza[username.toLowerCase()] = data
  msg.send "Ok, from now on I know that you get off work at "+endofshift+" end you work "+days+" days in one week."

module.exports = (robot) ->
  robot.brain.on 'loaded', ->
    hafiza = robot.brain.data.hafiza or {}	
  robot.respond /mesai/i, (msg) ->
    now = new Date
    hoursLeft = new Number(Math.round(18 - now.getHours()))
    minutesLeft = Math.round(60 - now.getMinutes())
    if 0 < now.getDay() < 6
      resp = if hoursLeft > 0 then "You have "+hoursLeft+" hours and "+minutesLeft+" minutes left to go, hang in there" else "\\o/ no more work for today, go & have fun"	  
    else 
      resp = if now.getDay() == 6 then "Life is a beach, enjoy it" else "I can, but I won't"
    msg.send resp

  robot.respond /I got off work at (\d+):(\d+)/i, (msg) -> 
    msg.send msg.match[1]+" - "+msg.match[2] 