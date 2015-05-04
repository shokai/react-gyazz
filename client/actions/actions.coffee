## Actions

module.exports = (app) ->

  socket = app.socket

  socket:
    setStatus: (status) ->
      @dispatch 'set-socket-status', status
