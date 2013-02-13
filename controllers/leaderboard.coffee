express = require "express"
request = require "request"
config = require "../config"

app = module.exports = express()

fannect = require "../utils/fannectAccess"

app.get "/", (req, res, next) ->

   fannect.request
      url: "/v1/teams/#{config.team_id}/groups"
      qs: { tags: "greek" }
   , (err, groups) ->
      return res.render("error", { error: err }) if err
      res.render "leaderboard", groups: groups