express = require "express"
request = require "request"

app = module.exports = express()

app.get "/:university", (req, res, next) ->
   res.render "leaderboard"