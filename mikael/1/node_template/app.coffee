express = require 'express'
require "coffee-script"
app = express()
http = require 'http'
server = http.createServer app
io = require('socket.io').listen server
stylus = require 'stylus'
nib = require 'nib'
coffeeware = require './coffeeware'
routes = require './routes'
application = require './application'
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.set 'view options', { layout: false } 
app.use coffeeware __dirname + '/public' 
app.use stylus.middleware { src: __dirname + '/public', compile: (str, path) -> stylus(str).set('filename', path).use nib() }
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.static __dirname + '/public'
app.use express.errorHandler { dumpExceptions: true, showStack: true }
io.set 'log level', 2

routes app

server.listen(3000)

request = require 'request'

jQ = require 'jQuery'

jsdom = require('jsdom')

jsdom.env
  html:'http://donjon.bin.sh/scifi/tsg/'
  features:
    FetchExternalResources: ["script"]
    ProcessExternalResources: ["script"]
  done: (errors, window)->
    setTimeout ->
      $ = window.$
      window.Event =
        observe: ->
      window.init_form()
      console.log $('system')
      $('system').select('tr').each (s)->
        console.log s.innerHTML
    , 20000

application(io)