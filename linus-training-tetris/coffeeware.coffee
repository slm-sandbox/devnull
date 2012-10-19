
fs = require 'fs'
coffee = require 'coffee-script'

module.exports = exports = (path)->
  (req, res, next)->
    if /\.coffee$/.test req.url
      fs.readFile path + req.url, (err, data)->
        res.type 'text/javascript'
        res.end coffee.compile data.toString()
    else
      next()
