# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

{Robot, Adapter, TextMessage, User} = require 'hubot'
crypto = require 'crypto'

gRes = {}

class Http extends Adapter
  send: (user, strings...) ->
    for str in strings
      json = {
        sendmms: true,
        showauthurl: false,
        authstate: null,
        text: str,
        speech: str,
        status: "OK",
        webhookreply: null,
        images: []
        # images: [
        #   {
        #     imageurl: "http://api.dev.promptapp.io/images/random/helloworld.gif",
        #     alttext: "Hello World!"
        #   }
        # ]
      }
      gRes.setHeader 'content-type', 'application/json'
      gRes.end JSON.stringify(json)

  reply: (user, strings...) ->
    console.log 'Reply'
    @send user, strings.map((str) -> "#{user.user}: #{str}")...

  run: ->
    console.log "Starting up " + @robot.name
    @emit "connected"

    @robot.router.post '/api/1.0/:cmd', (req, res) =>
      cmd = req.params.cmd || 'xkcd'
      # Build user
      userId = req.body.uuid || 1
      user = @robot.brain.userForId userId, name: "Hung Dao", room: 'Shell'

      console.log "cmd => #{cmd}"
      console.log "#{user.name} => #{req.body.message}"


      msg = "cloe #{cmd}"
      msg += " #{req.body.message}" if req.body.message
      message = new TextMessage user, msg
      @robot.receive message
      gRes = res

exports.use = (robot) ->
  new Http robot

