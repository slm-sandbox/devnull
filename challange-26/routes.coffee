index = (req, res) ->
  res.render 'index', { title: 'Awesome app' }

module.exports = (app) ->
  app.get '/', index

