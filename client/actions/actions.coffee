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

    insertNewLine: (linenum) ->
      @dispatch 'insert-new-line', linenum
      @dispatch 'set-edit-line', linenum
