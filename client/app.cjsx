React   = require 'react'
Fluxxor = require 'fluxxor'

query   = "wiki=#{encodeURIComponent page.wiki}&title=#{encodeURIComponent page.title}"
socket  = require('socket.io-client').connect "#{location.protocol}//#{location.host}?#{query}"

app =
  socket:
    io: socket
  pkg: require '../package.json'

## flux = stores, actions
app.flux = new Fluxxor.Flux
  Page:   new (require('./stores/page')(app))
  Socket: new (require('./stores/socket')(app))
, require('./actions/actions')(app)

## Other Components
app.socket.page = require('./sockets/page')(app)

## View
View = require './views/main'

React.render <View flux={app.flux} />
, document.getElementById 'app-container'
