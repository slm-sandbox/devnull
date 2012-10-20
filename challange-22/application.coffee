module.exports = (io) ->
  console.log('application loaded')

  messages = []

  dgram = require "dgram"
  server = dgram.createSocket "udp4"

  server.on "message", (msg, rinfo)->
    console.log("server got: " + msg + " from " + rinfo.address + ":" + rinfo.port)
    messages.push msg
    setTimeout ->
      messages.shift()
    , 60000
    io.sockets.emit 'msg', msg

  server.on "listening", ->
    address = server.address()
    console.log("server listening " + address.address + ":" + address.port)

  server.bind(9001);

  io.sockets.on 'connection', (socket)->

    username = null

    for msg in messages
      socket.emit 'msg', msg

    socket.on 'join', (name)->
      username = name

    socket.on 'send', (msg)->
      return unless username
      m = new Buffer username + " " + msg
      server.send m, 0, m.length, 9001, '255.255.255.255'
