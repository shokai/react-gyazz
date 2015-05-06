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
      @bindActions 'swap-next-line', @swapNextLine
      @bindActions 'swap-prev-line', @swapPrevLine
      @bindActions 'swap-next-block', @swapNextBlock
      @bindActions 'swap-prev-block', @swapPrevBlock

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
      @removeEmptyLine()
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
      indent = @getIndentLevel @lines[linenum-1]
      spaces = [0...indent]
        .map (i) -> " "
        .join ''
      @lines.splice linenum, 0, spaces
      @setEditLine linenum

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
      offsets = [linenum, null]
      currentIndent = @getIndentLevel @lines[linenum]
      for i in [linenum+1...@lines.length]
        indent = @getIndentLevel @lines[i]
        if indent <= currentIndent
          offsets[1] = i-1
          break
      unless offsets[1]
        offsets[1] = @lines.length-1
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

    removeEmptyLine: ->
      @lines = _
        .chain @lines
        .reject (line) -> /^\s*$/.test line
        .map (line) ->
          line
          .replace /\s+$/, ''
          .replace /^\s{10,}/, '          '
        .value()
      @emit 'change'

    save: ->
      app.socket.page.save @lines.join '\n'
