express = require 'express'
require "coffee-script"
routes = require './routes'
app = module.exports = express()
io = require('socket.io').listen app

compile = (str, path) ->
  return stylus(str).set('filename', path).use(nib())

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static __dirname + '/public'

app.configure 'development', ->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
  app.use express.errorHandler()

routes app

if (require.main == module)
  app.listen(3000)

