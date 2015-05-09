## Socket page

module.exports = (app) ->

  io = app.socket.io

  io.on 'connect', ->
    console.log 'connect!!'
    app.flux.actions.socket.setStatus 'connecting'

  io.on 'disconnect', ->
    app.flux.actions.editor.disable()
    app.flux.actions.socket.setStatus 'closed..'

  io.on 'pagedata', (page) ->
    lines = page.text.split(/[\r\n]+/)
    console.log "received pagedata"
    app.flux.actions.editor.setLines lines
    app.flux.actions.editor.enable()

  save: (text) ->
    io.emit 'pagedata',
      text: text
