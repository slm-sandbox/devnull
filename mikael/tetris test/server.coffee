express = require 'express'
app = express()

app.use express.static __dirname, + '/public'

app.get '/', (req, res)=>
  res.sendfile 'index.html'

app.listen 3000
console.log 'Listening on :3000'