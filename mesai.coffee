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
  username = username.toLowerCase()  
  hafiza[username] ?= {}
  hafiza[username]["endofshiftHH"] = endofshiftHH
  hafiza[username]["endofshiftMM"] = endofshiftMM
  msg.send "Ok, I know that your shift ends at "+hafiza[username]["endofshiftHH"]+":"+hafiza[username]["endofshiftMM"]

saveDays = (msg, username, days) ->
  username = username.toLowerCase()    
  hafiza[username] ?= {}
  hafiza[username]["days"] = days
  msg.send "Ok, I know that you work "+days+" days"  

save = (robot) ->
  robot.brain.data.hafiza = hafiza  

module.exports = (robot) ->
  robot.brain.on 'loaded', ->
    hafiza = robot.brain.data.hafiza or {}	

  robot.hear /mesai/i, (msg) ->
    username = msg.message.user.name.toLowerCase()
    hafiza[username] ?= {}
    hafiza[username]["endofshiftHH"] ?= 18
    hafiza[username]["endofshiftMM"] ?= 60
    hafiza[username]["days"] ?= 5

    if hafiza[username]["endofshiftMM"] == 0 then hafiza[username]["endofshiftMM"] = 60 

    now = new Date
    hoursLeft = new Number(Math.round(hafiza[username]["endofshiftHH"] - now.getHours()))
    minutesLeft = Math.round(hafiza[username]["endofshiftMM"] - now.getMinutes())
    if 0 < now.getDay() < new Number(hafiza[username]["days"]) +1 
      resp = if hoursLeft > 0 then "You have "+hoursLeft+" hours and "+minutesLeft+" minutes left to go, hang in there" else "\\o/ no more work for today, go & have fun"	  
    else 
      resp = if now.getDay() == 6 then "Life is a beach, enjoy it" else "I can, but I won't"
    msg.send resp

  robot.respond /My shift ends at (\d+):(\d+)/i, (msg) -> 
    saveEndofshift(msg, msg.message.user.name, msg.match[1], msg.match[2])
    save(robot)
  robot.respond /I work (\d+) days/i, (msg) -> 
    saveDays(msg, msg.message.user.name, msg.match[1], msg.match[2])
    save(robot)  
  robot.respond /When will my shift ends/i, (msg) -> 
    username = msg.message.user.name.toLowerCase()
    hafiza[username] ?= {}
    hafiza[username]["endofshiftHH"] ?= "18"
    hafiza[username]["endofshiftMM"] ?= "00"
    if hafiza[username]["endofshiftMM"] == "0" then hafiza[username]["endofshiftMM"] = "00"
    
    hafiza[username]["days"] ?= "5"
    msg.send "Your shift ends at "+hafiza[username]["endofshiftHH"]+":"+hafiza[username]["endofshiftMM"]+" and you work "+hafiza[username]["days"]+" in one week."
    
  robot.respond /mesai help/i, (msg) -> 
    msg.send "You can just mention the word: mesai and I tell you how much time left until you started the PARTY!"  
    msg.send "You can tell me to rememmber when your shift ends with the command: My shift ends at HH:MM"
    msg.send "You can tell me how many days that you work in a week with the command: I work N days"
    msg.send "You can check your settings with the command: Whel will my shift ends"

