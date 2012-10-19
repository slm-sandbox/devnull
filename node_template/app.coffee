express = require 'express'
require "coffee-script"
app = express()
server = require('http').createServer app
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

routes app

server.listen(3000)
application(io)

