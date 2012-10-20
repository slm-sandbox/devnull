http = require 'http'
express = require 'express'
coffee = require 'coffee-script'
socketio = require 'socket.io'
coffeeware = require './coffeeware'
jquery = require 'express-jquery'

app = express()
server = http.createServer app
io = socketio.listen server

app.use express.bodyParser()
app.use jquery '/jquery.js'
app.use coffeeware __dirname + '/assets'
app.use express.static __dirname + '/public'

server.listen 1337

app.get '/', (req,res)->
  res.sendfile 'index.html'

io.sockets.on 'connection', (socket)->
  socket.on 'get-data', ->
    socket.emit 'update', [9,7,3,5]
