
colors = require 'colors'
request = require 'request'

url = 'http://api.stockholm.se/ServiceGuideService/ServiceUnitTypes/10031f76-001a-4a00-9e2a-3b1a166ebf6f/ServiceUnits/json?apikey=0368698385f14e72a9680fbd3d635155'

request url, (err, res, body)->
  a = JSON.parse body
  for simhall in a
    ((simhall)->
      request "http://api.stockholm.se/ServiceGuideService/ServiceUnits/#{simhall.Id}/Attributes/json?apikey=0368698385f14e72a9680fbd3d635155", (err, res, body)->
        arr = JSON.parse body
        for attr in arr
          if attr.Id is 'StreetAddress'
            console.log simhall.Name.bold
            console.log attr.Value
    )(simhall)
