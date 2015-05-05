## Store: Page

Fluxxor = require 'fluxxor'

module.exports = (app) ->

  Fluxxor.createStore

    initialize: ->
      @editline = null
      @lines = window.lines or ['(empty)']
      @bindActions 'set-edit-line', @setEditLine
      @bindActions 'set-line', @setLine
      @bindActions 'insert-new-line', @insertNewLine

    getState: ->
      lines: @lines
      editline: @editline

    setEditLine: (@editline) -> @emit 'change'

    setLine: (args) ->
      @lines[args.editline] = args.value
      @emit 'change'

    insertNewLine: (linenum) ->
      @lines.splice linenum, 0, ""
