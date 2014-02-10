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

saveEndofshift = (msg, username, endofshiftHH, endofshiftMM) ->
  msg.send "func called with username: "+username+" endofshiftHH: "+endofshiftHH+" and endofshiftMM: "+endofshiftMM
  hafiza[username] ?= {}
  msg.send "username space declered"
  tmp = {}
  tmp[endofshift] = endofshiftHH+":"+endofshiftMM
  msg.send "tmp data prepared"
  hafiza[username] = tmp
  msg.send "after preperation"
  msg.send "Ok, from now on I know that your shift ends at "+tmp[endofshift]

saveDays = (msg, username, days) ->
  data = {}
  data[days] = days
  hafiza[username.toLowerCase()] ?= {}
  hafiza[username.toLowerCase()] = data
  msg.send "Ok, from now on I know that you work "+days+" days in a week"  

save = (robot) ->
  robot.brain.data.hafiza = hafiza  

module.exports = (robot) ->
  robot.brain.on 'loaded', ->
    hafiza = robot.brain.data.hafiza or {}	

  robot.hear /mesai/i, (msg) ->
    now = new Date
    hoursLeft = new Number(Math.round(18 - now.getHours()))
    minutesLeft = Math.round(60 - now.getMinutes())
    if 0 < now.getDay() < 6
      resp = if hoursLeft > 0 then "You have "+hoursLeft+" hours and "+minutesLeft+" minutes left to go, hang in there" else "\\o/ no more work for today, go & have fun"	  
    else 
      resp = if now.getDay() == 6 then "Life is a beach, enjoy it" else "I can, but I won't"
    msg.send resp

  robot.respond /My shift ends at (\d+):(\d+)/i, (msg) -> 
    msg.send "I hear you "+hafiza
    saveEndofshift(msg, msg.message.user.name, msg.match[1], msg.match[2])
    save(robot)
  robot.respond /I work (\d+) days/i, (msg) -> 
    saveEndofshift(msg, msg.message.user.name, msg.match[1], msg.match[2])
    save(robot)  
  robot.respond /When will my shift end/i, (msg) -> 
    username = msg.message.user.name.toLowerCase()
    hafiza[username] ?= {}
    msg.send "Your shift ends at "+hafiza[username][endofshift]+" and you work "+hafiza[username][days]+" in one week."
