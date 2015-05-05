## Actions

module.exports = (app) ->

  socket:
    setStatus: (status) ->
      @dispatch 'set-socket-status', status

  editor:
    edit: (num) ->
      @dispatch 'set-edit-line', num
      @dispatch 'remove-empty-line'

    editPrevLine: ->
      @dispatch 'edit-prev-line'
      @dispatch 'remove-empty-line'

    editNextLine: ->
      @dispatch 'edit-next-line'
      @dispatch 'remove-empty-line'

    setLine: (args) ->
      @dispatch 'set-line', args

    setLines: (lines) ->
      @dispatch 'set-lines', lines

    indentRight: ->
      @dispatch 'indent-right'

    indentLeft: ->
      @dispatch 'indent-left'

    insertNewLine: (linenum) ->
      @dispatch 'remove-empty-line'
      @dispatch 'insert-new-line', linenum
      @dispatch 'set-edit-line', linenum
