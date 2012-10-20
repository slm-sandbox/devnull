$ ->
  audio = $('audio').get(0)

  dancer = new Dancer()
  dancer.load audio
  dancer.play()
  kickTest = false

  window.kick = dancer.createKick
    frequency: [0,2]
    threshold: 0.6
    onKick: ->
      console.log 'kick'
      kickTest = true
      setTimeout 100, kickTest = false

  kick.on()

  $('#threshold').on 'change', (s)->
    kick.threshold = s.srcElement.value

  $('#frequencyMin').on 'change', (s)->
    kick.frequency[0] = s.srcElement.value

  $('#frequencyMax').on 'change', (s)->
    kick.frequency[1] = s.srcElement.value