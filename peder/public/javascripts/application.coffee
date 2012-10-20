socket = io.connect 'http://localhost:3000'
socket.on 'news', (data) ->
  console.log data

socket.on 'step', (data) ->
  console.log 'step'

socket.on 'game over', (data) ->
  console.log 'GAME OVER'


  

