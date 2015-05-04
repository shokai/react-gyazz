## Actions

module.exports = (app) ->

  socket = app.socket

  socket:
    setStatus: (status) ->
      @dispatch 'set-socket-status', status

  editor:
    edit: (num) ->
      @dispatch 'set-edit-line', num

    setLine: (args) ->
      @dispatch 'set-line', args
