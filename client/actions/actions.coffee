## Actions

module.exports = (app) ->

  socket:
    setStatus: (status) ->
      @dispatch 'set-socket-status', status

  editor:
    edit: (num) ->
      @dispatch 'set-edit-line', num
      @dispatch 'remove-empty-lines'

    editPrevLine: ->
      @dispatch 'edit-prev-line'
      @dispatch 'remove-empty-lines'

    editNextLine: ->
      @dispatch 'edit-next-line'
      @dispatch 'remove-empty-lines'

    setLine: (args) ->
      @dispatch 'set-line', args

    setLines: (lines) ->
      @dispatch 'set-lines', lines

    indentRight: ->
      @dispatch 'indent-right'

    indentLeft: ->
      @dispatch 'indent-left'

    insertNewLine: ->
      @dispatch 'remove-empty-lines'
      @dispatch 'insert-new-line'

    swapNextLine: ->
      @dispatch 'swap-next-line'

    swapPrevLine: ->
      @dispatch 'swap-prev-line'

    swapNextBlock: ->
      @dispatch 'swap-next-block'

    swapPrevBlock: ->
      @dispatch 'swap-prev-block'
