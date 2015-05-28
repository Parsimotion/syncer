_ = require("lodash")

ProductecaApi = require("producteca-sdk").Api
Syncer = require("producteca-sdk").Sync.Syncer
Parsers = require("./parsers/parsers")
config = require("../config/environment")

module.exports =

class DataSource
  constructor: (@user, @settings) ->
    @productecaApi = new ProductecaApi
      accessToken: @user.tokens.parsimotion
      url: config.parsimotion.uri

  getAjustes: => throw new Error "not implemented"

  sync: =>
    @getAjustes()
      .then (resultado) =>
        @productecaApi.getProducts().then (productos) =>
          new Syncer(@productecaApi, @user.settings, productos)
            .execute resultado.ajustes
      .then (lastSync) =>
        lastSync.date = Date.now()
        @user.lastSync = lastSync
        @user.history.push _.mapValues lastSync, (items) =>
          if _.isArray items then items.length
          else items
        @user.save()
        lastSync

  _parse: (ajustes) => @_getParser().getAjustes ajustes

  _getParser: => new (require("./parsers/#{@settings.parser}Parser")) @settings