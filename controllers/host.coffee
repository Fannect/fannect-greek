express = require "express"
# MongoStore = require("connect-mongo")(express)
config = require "../config/app"
path = require "path"

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
app.use express.static path.join __dirname, "../public"
# app.use express.cookieParser process.env.COOKIE_SECRET or "super duper secret"
# app.use express.session()
#    # store: new MongoStore(url: config.session_store)
# app.use require("connect-assets")()

# Controllers
app.use require "./leaderboard"