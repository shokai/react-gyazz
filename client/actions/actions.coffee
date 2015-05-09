## Actions

module.exports = (app) ->

  socket:
    setStatus: (status) ->
      @dispatch 'set-socket-status', status

  editor:
    enable: ->
      @dispatch 'edit-enable', true

    disable: ->
      @dispatch 'edit-enable', false

    edit: (num) ->
      @dispatch 'set-edit-line', num

    editPrevLine: ->
      @dispatch 'edit-prev-line'

    editNextLine: ->
      @dispatch 'edit-next-line'

    setLine: (args) ->
      @dispatch 'set-line', args

    setLines: (lines) ->
      @dispatch 'set-lines', lines

    indentRight: ->
      @dispatch 'indent-right'

    indentLeft: ->
      @dispatch 'indent-left'

    insertNewLine: ->
      @dispatch 'insert-new-line'

    swapNextLine: ->
      @dispatch 'swap-next-line'

    swapPrevLine: ->
      @dispatch 'swap-prev-line'

    swapNextBlock: ->
      @dispatch 'swap-next-block'

    swapPrevBlock: ->
      @dispatch 'swap-prev-block'
