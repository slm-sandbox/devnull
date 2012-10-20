
jsdom = require 'jsdom'
colors = require 'colors'

jsdom.env
  html: 'http://donjon.bin.sh/scifi/tsg/'
  features:
    FetchExternalResources: ["script"]
    ProcessExternalResources: ["script"]
  done: (errors, window)->
    setTimeout ->
      $ = window.$
      window.Event =
        observe: ->
      window.init_form()
      console.log 'The stars:'.bold
      for e in $('system').select('td.value')
        console.log e.textContent
      console.log ''
      for e in $('planet').select('tr')
        continue unless e.childElements()[1]
        console.log e.firstChild.textContent.bold
        console.log e.childElements()[1].textContent
        console.log ''
    , 20000
