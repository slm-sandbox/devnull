controllers = require './controllers'

module.exports = (app) ->
  app.get '/', controllers.index

