module.exports = (app) ->

  app.socket.io.on 'connect', ->
    console.log 'connect!!'
    app.flux.actions.socket.setStatus 'connecting'

  app.socket.io.on 'disconnect', ->
    app.flux.actions.socket.setStatus 'closed..'
