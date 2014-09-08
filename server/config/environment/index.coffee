requiredProcessEnv = (name) ->
  throw new Error("You must set the " + name + " environment variable")  unless process.env[name]
  process.env[name]
"use strict"
path = require("path")
_ = require("lodash")

# All configurations will extend these options
# ============================================
all =
  env: process.env.NODE_ENV

  # Root path of server
  root: path.normalize(__dirname + "/../../..")

  # Server port
  port: process.env.PORT or 9000

  # Should we populate the DB with sample data?
  seedDB: false

  # Secret for session, you will want to change this and make it an environment variable
  secrets:
    session: "parsimotion-syncer-secret"


  # List of user roles
  userRoles: [
    "guest"
    "user"
    "admin"
  ]

  # MongoDB connection options
  mongo:
    options:
      db:
        safe: true

  dropbox:
    clientID: process.env.DROPBOX_ID or "id"
    clientSecret: process.env.DROPBOX_SECRET or "secret"
    callbackURL: (process.env.DOMAIN or "") + "/auth/dropbox/callback"

  parsimotion:
    uri: process.env.PARSIMOTION_URI or "http://api.parsimotion.com"

# Export the config object based on the NODE_ENV
# ==============================================
module.exports = _.merge(all, require("./" + process.env.NODE_ENV + ".coffee") or {})
