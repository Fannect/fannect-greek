express = require "express"
path = require "path"
fannect = require "../utils/fannectAccess"
fannect {
   login_url: process.env.LOGIN_URL or "http://localhost:2200"
   resource_url: process.env.RESOURCE_URL or "http://localhost:2100"
   client_id: process.env.CLIENT_ID or "some_clientid"
   client_secret: process.env.CLIENT_SECRET or "clientsecret"
}

app = module.exports = express()

# Settings
app.set "view engine", "jade"
app.set "view options", layout: false
app.set "views", path.join __dirname, "../views"

app.configure "development", () ->
   app.use express.logger "dev"
   app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure "production", () ->
   app.use express.errorHandler()

# Middleware
app.use express.query()
app.use express.bodyParser()
app.use require("connect-assets")()
app.use express.static path.join __dirname, "../public"

# Controllers
app.use require "./leaderboard"