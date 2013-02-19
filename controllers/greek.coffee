express = require "express"
request = require "request"
config = require "../config"

app = module.exports = express()

fannect = require "../utils/fannectAccess"

app.get "/:school", (req, res, next) ->
   school = config[req.params.school]
   fannect.request
      url: "/v1/teams/#{school.team_id}/groups"
      qs: { tags: "greek" }
   , (err, groups) ->
      return res.render("error", { error: err }) if err
      res.render "layout", { groups: groups, config: school }

app.post "/", (req, res, next) ->
   group_id = req.body.group_id
   email = req.body.email
   fannect.request
      url: "/v1/groups/#{group_id}/teamprofiles"
      method: "POST"
      json: { email: email }
   , (err, body) ->
      res.json body