## Store: Page

Fluxxor = require 'fluxxor'
_       = require 'lodash'

validator = require '../../libs/validator'

module.exports = (app) ->

  Fluxxor.createStore

    initialize: ->
      @editline = null
      @lines = window.page.text.split(/[\r\n]+/)
      @removeEmptyLines()
      @bindActions 'edit-enable', @setEnable
      @bindActions 'set-edit-line', @setEditLine
      @bindActions 'edit-prev-line', @editPrevLine
      @bindActions 'edit-next-line', @editNextLine
      @bindActions 'set-line', @setLine
      @bindActions 'set-lines', @setLines
      @bindActions 'indent-right', @indentRight
      @bindActions 'indent-left', @indentLeft
      @bindActions 'insert-new-line', @insertNewLine
      @bindActions 'swap-next-line', @swapNextLine
      @bindActions 'swap-prev-line', @swapPrevLine
      @bindActions 'swap-next-block', @swapNextBlock
      @bindActions 'swap-prev-block', @swapPrevBlock

    getState: ->
      lines: @lines
      editline: @editline
      enable: @enable

    setEnable: (@enable) ->
      @emit 'change'

    setEditLine: (linenum) ->
      if typeof linenum is 'number'
        @editline = _.min [linenum, @lines.length-1]
      else
        @editline = linenum
        @removeEmptyLines()
      @emit 'change'

    editPrevLine: ->
      return unless @editline > 0
      @setEditLine @editline-1
      @removeEmptyLines()
      @emit 'change'

    editNextLine: ->
      return unless @editline < @lines.length-1
      @setEditLine @editline+1
      @removeEmptyLines()
      @emit 'change'

    setLine: (args) ->
      @lines[args.editline] = args.value.split(/\n/)
      @lines = _.flatten @lines
      @emit 'change'
      @save()

    setLines: (lines) ->
      @lines = lines
      @removeEmptyLines()
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

    insertNewLine: ->
      @removeEmptyLines()
      indent = @getIndentLevel @lines[@editline]
      spaces = [0...indent]
        .map (i) -> " "
        .join ''
      @lines.splice @editline+1, 0, spaces
      @setEditLine @editline+1

    swapPrevLine: ->
      return if @editline < 1
      line = @lines[@editline]
      @lines[@editline] = @lines[@editline-1]
      @lines[@editline-1] = line
      @editline -= 1
      @emit 'change'
      @save()

    swapNextLine: ->
      return unless @editline < @lines.length-1
      line = @lines[@editline]
      @lines[@editline] = @lines[@editline+1]
      @lines[@editline+1] = line
      @editline += 1
      @emit 'change'
      @save()

    getIndentLevel: (line) ->
      line.match(/^(\s*)/)[0].length

    getBlockOffsets: (linenum) ->
      offsets = [linenum, linenum]
      currentIndent = @getIndentLevel @lines[linenum]
      for i in [linenum+1...@lines.length]
        indent = @getIndentLevel @lines[i]
        if indent > currentIndent
          offsets[1] = i
        else
          break
      return offsets

    getBlock: (offsets) ->
      @lines.concat().splice offsets[0], offsets[1]-offsets[0]+1

    ## 現在の行が属するblockを、前のblockと入れ替える
    swapPrevBlock: ->
      return if @editline < 1
      currentOffsets = @getBlockOffsets @editline
      currentIndent = @getIndentLevel @lines[@editline]
      prevOffsets = [null, @editline-1]
      for i in [@editline-1..0]
        indent = @getIndentLevel @lines[i]
        if indent < currentIndent
          return
        if indent is currentIndent
          prevOffsets[0] = i
          break
      return if prevOffsets[0] is null
      @lines = []
        .concat @getBlock([0, prevOffsets[0]-1])
          , @getBlock(currentOffsets)
          , @getBlock(prevOffsets)
          , @getBlock([currentOffsets[1]+1, @lines.length-1])
      @editline = prevOffsets[0]
      @emit 'change'
      @save()

    ## 現在の行が属するblockを、次のblockと入れ替える
    swapNextBlock: ->
      return unless @editline < @lines.length-1
      currentOffsets = @getBlockOffsets @editline
      indent = @getIndentLevel @lines[@editline]
      return unless currentOffsets[1]+1 < @lines.length
      return if indent isnt @getIndentLevel @lines[currentOffsets[1]+1]
      nextOffsets = @getBlockOffsets currentOffsets[1]+1
      @lines = []
        .concat @getBlock([0, currentOffsets[0]-1])
          , @getBlock(nextOffsets)
          , @getBlock(currentOffsets)
          , @getBlock([nextOffsets[1]+1, @lines.length-1])
      @editline = @editline + 1 + nextOffsets[1] - nextOffsets[0]
      @emit 'change'
      @save()

    removeEmptyLines: ->
      @lines = validator
        .removeEmptyLines @lines
        .map (line) ->
          line.replace /^\s{10,}/, '          ' # limit 10 indent

      if @editline > @lines.length-1
        @editline = @lines.length-1
      @lines = ['(empty)'] if @lines.length < 1

    save: ->
      app.socket.page.save @lines.join '\n'
