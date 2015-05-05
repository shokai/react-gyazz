module.exports = (app) ->

  io = app.socket.io

  io.on 'connect', ->
    console.log 'connect!!'
    app.flux.actions.socket.setStatus 'connecting'

  io.on 'disconnect', ->
    app.flux.actions.socket.setStatus 'closed..'

  save: (text) ->
    io.emit 'pagedata',
      text: text
