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
      @bindActions 'indent-right', @indentRight
      @bindActions 'indent-left', @indentLeft
      @bindActions 'insert-new-line', @insertNewLine
      @bindActions 'remove-empty-line', @removeEmptyLine

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

    indentRight: ->
      line = @lines[@editline]
      @lines[@editline] = ' '+line
      @emit 'change'

    indentLeft: ->
      line = @lines[@editline]
      @lines[@editline] = line.replace /^\s/, ''
      @emit 'change'

    insertNewLine: (linenum) ->
      @lines.splice linenum, 0, ""

    removeEmptyLine: ->
      @lines = _.reject @lines, (line) -> /^\s*$/.test line
      @emit 'change'
