## Store: Page

Fluxxor = require 'fluxxor'
_       = require 'lodash'

module.exports = (app) ->

  Fluxxor.createStore

    initialize: ->
      @editline = null
      @lines = window.page.text.split(/[\r\n]+/) or ['(empty)']
      @bindActions 'set-edit-line', @setEditLine
      @bindActions 'edit-prev-line', @editPrevLine
      @bindActions 'edit-next-line', @editNextLine
      @bindActions 'set-line', @setLine
      @bindActions 'set-lines', @setLines
      @bindActions 'indent-right', @indentRight
      @bindActions 'indent-left', @indentLeft
      @bindActions 'insert-new-line', @insertNewLine
      @bindActions 'remove-empty-line', @removeEmptyLine
      @bindActions 'flip-next-line', @flipNextLine
      @bindActions 'flip-prev-line', @flipPrevLine
      @bindActions 'flip-next-block', @flipNextBlock
      @bindActions 'flip-prev-block', @flipPrevBlock

    getState: ->
      lines: @lines
      editline: @editline

    setEditLine: (linenum) ->
      @editline = _.min [linenum, @lines.length-1]
      @emit 'change'

    editPrevLine: ->
      if @editline > 0
        @setEditLine @editline-1

    editNextLine: ->
      if @editline < @lines.length-1
        @setEditLine @editline+1

    setLine: (args) ->
      @lines[args.editline] = args.value
      @emit 'change'
      @save()

    setLines: (lines) ->
      @lines = lines
      @emit 'change'

    indentRight: ->
      line = @lines[@editline]
      @lines[@editline] = ' '+line
      @emit 'change'
      @save()

    indentLeft: ->
      line = @lines[@editline]
      @lines[@editline] = line.replace /^\s/, ''
      @emit 'change'
      @save()

    insertNewLine: (linenum) ->
      @lines.splice linenum, 0, ""

    flipPrevLine: ->
      return if @editline < 1
      line = @lines[@editline]
      @lines[@editline] = @lines[@editline-1]
      @lines[@editline-1] = line
      @editline -= 1
      @emit 'change'

    flipNextLine: ->
      return unless @editline < @lines.length-1
      line = @lines[@editline]
      @lines[@editline] = @lines[@editline+1]
      @lines[@editline+1] = line
      @editline += 1
      @emit 'change'

    flipPrevBlock: ->
      console.log 'flipPrevBlock'

    flipNextBlock: ->
      console.log 'flipNextBlock'

    removeEmptyLine: ->
      @lines = _.reject @lines, (line) -> /^\s*$/.test line
      @emit 'change'

    save: ->
      app.socket.page.save @lines.join '\n'
