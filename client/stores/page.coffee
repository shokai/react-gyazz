## Store: Page

Fluxxor = require 'fluxxor'
_       = require 'lodash'

module.exports = (app) ->

  Fluxxor.createStore

    initialize: ->
      @editline = null
      @lines = window.lines or ['(empty)']
      @bindActions 'set-edit-line', @setEditLine
      @bindActions 'set-line', @setLine
      @bindActions 'insert-new-line', @insertNewLine
      @bindActions 'remove-empty-line', @removeEmptyLine

    getState: ->
      lines: @lines
      editline: @editline

    setEditLine: (linenum) ->
      @editline = _.min [linenum, @lines.length-1]
      @emit 'change'

    setLine: (args) ->
      @lines[args.editline] = args.value
      @emit 'change'

    insertNewLine: (linenum) ->
      @lines.splice linenum, 0, ""

    removeEmptyLine: ->
      @lines = _.reject @lines, (line) -> /^\s*$/.test line
      @emit 'change'
