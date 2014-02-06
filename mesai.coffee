# Description
#   Just a simple script to track how much time left for work day to end. 
#
# Dependencies:
#   
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot <mesai> - <gives HH:MM response to how much time left for the work day to end>
#   <mesai> - <gives HH:MM response to how much time left for the work day to end>
#
# Notes:
#   <>
#
# Author:
#   @gcg

module.exports = (robot) ->
  robot.hear /mesai/i, (msg) ->
    msg.send "Time to go: "