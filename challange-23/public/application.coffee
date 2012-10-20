$ ->

  video = document.createElement 'video'
  document.body.appendChild video

  navigator.webkitGetUserMedia { video: true }, (s)->
    video.src = webkitURL.createObjectURL s
    video.play()
