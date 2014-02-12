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
#   <When will my shift end> - Responds with the working hour data at the brain
#   <When will USERNAME get off work> - Responds with the working hour data at the brain for USERNAME
#   <My shift ends at HH:MM> - Save your shift end time with HH:MM format (default: 18:00)
#   <I work N days> - Save how many days that you work in one week (default: 5)
#   <m USERNAME> - <gives HH:MM response to how much time left for username for work day to end>
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

    hafiza[username]["endofshiftMM"] = 60 if hafiza[username]["endofshiftMM"] == "00"
    hafiza[username]["endofshiftMM"] = 60 if hafiza[username]["endofshiftMM"] > 60 

    now = new Date
    hoursLeft = new Number(Math.round(hafiza[username]["endofshiftHH"] - now.getHours()))
    minutesLeft = new Number(Math.round(hafiza[username]["endofshiftMM"] - now.getMinutes()))

    minutesLeft = 0 if minutesLeft < 0 and hafiza[username]["endofshiftMM"] == 60
    minutesLeft = 60 - (new Number(hafiza[username]["endofshiftMM"]) + Math.abs(minutesLeft)) if minutesLeft < 0 and hafiza[username]["endofshiftMM"] < 60

    hoursLeft = hoursLeft - 1 if 0 < minutesLeft and hafiza[username]["endofshiftMM"] == 60
    hoursLeft = hoursLeft - 1 if new Number(Math.round(hafiza[username]["endofshiftMM"] - now.getMinutes())) < 0 and hafiza[username]["endofshiftMM"] < 60


    days = new Number(hafiza[username]["days"] + 1)

    if 0 < now.getDay() < days
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
  robot.respond /When will my shift end/i, (msg) -> 
    username = msg.message.user.name.toLowerCase()
    hafiza[username] ?= {}
    hafiza[username]["endofshiftHH"] ?= "18"
    hafiza[username]["endofshiftMM"] ?= "00"
    if hafiza[username]["endofshiftMM"] == "0" then hafiza[username]["endofshiftMM"] = "00"
    if hafiza[username]["endofshiftMM"] > "59" then hafiza[username]["endofshiftMM"] = "00"
    
    hafiza[username]["days"] ?= "5"
    msg.send "Your shift will end at "+hafiza[username]["endofshiftHH"]+":"+hafiza[username]["endofshiftMM"]+" and you work "+hafiza[username]["days"]+" days in one week."

  robot.respond /When will (.*?) get off work/i, (msg) ->
    username = msg.match[1].toLowerCase()
    hafiza[username] ?= {}
    hafiza[username]["endofshiftHH"] ?= "18"
    hafiza[username]["endofshiftMM"] ?= "00"
    if hafiza[username]["endofshiftMM"] == "0" then hafiza[username]["endofshiftMM"] = "00"
    if hafiza[username]["endofshiftMM"] > "59" then hafiza[username]["endofshiftMM"] = "00"
    
    hafiza[username]["days"] ?= "5"
    msg.send username+"'s shift will end at "+hafiza[username]["endofshiftHH"]+":"+hafiza[username]["endofshiftMM"]+" and works "+hafiza[username]["days"]+" days in one week."


  robot.respond /m (.*?)\s?$/i, (msg) -> 
    username = msg.match[1].toLowerCase()
    hafiza[username] ?= {}
    hafiza[username]["endofshiftHH"] ?= 18
    hafiza[username]["endofshiftMM"] ?= 60
    hafiza[username]["days"] ?= 5

    hafiza[username]["endofshiftMM"] = 60 if hafiza[username]["endofshiftMM"] == "00"
    hafiza[username]["endofshiftMM"] = 60 if hafiza[username]["endofshiftMM"] > 60 

    now = new Date
    hoursLeft = new Number(Math.round(hafiza[username]["endofshiftHH"] - now.getHours()))
    minutesLeft = new Number(Math.round(hafiza[username]["endofshiftMM"] - now.getMinutes()))

    minutesLeft = 0 if minutesLeft < 0 and hafiza[username]["endofshiftMM"] == 60
    minutesLeft = 60 - (new Number(hafiza[username]["endofshiftMM"]) + Math.abs(minutesLeft)) if minutesLeft < 0 and hafiza[username]["endofshiftMM"] < 60

    hoursLeft = hoursLeft - 1 if 0 < minutesLeft and hafiza[username]["endofshiftMM"] == 60
    hoursLeft = hoursLeft - 1 if new Number(Math.round(hafiza[username]["endofshiftMM"] - now.getMinutes())) < 0 and hafiza[username]["endofshiftMM"] < 60

    days = new Number(hafiza[username]["days"] + 1)

    if 0 < now.getDay() < days
      resp = if hoursLeft > 0 then username+" has "+hoursLeft+" hours and "+minutesLeft+" minutes left to go" else "\\o/ no more work for today, go & have fun"   
    else 
      resp = if now.getDay() == 6 then "Life is a beach, enjoy it" else "I can, but I won't"
    msg.send resp
