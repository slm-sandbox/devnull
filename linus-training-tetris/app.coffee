
http = require 'http'
express = require 'express'
coffee = require 'coffee-script'
socketio = require 'socket.io'
coffeeware = require './coffeeware'
jquery = require 'express-jquery'

Client = require './Client'

app = express()
server = http.createServer app
io = socketio.listen server

io.set 'log level', 2

app.use express.bodyParser()
app.use jquery '/jquery.js'
app.use coffeeware __dirname + '/assets'
app.use express.static __dirname + '/public'

server.listen 1337

Client.setup io
io.sockets.on 'connection', (socket)-> new Client socket
