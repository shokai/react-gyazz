## View: Editor

React   = require 'react'
Fluxxor = require 'fluxxor'

util = require('./util')

style =
  input:
    width: '80%'
    height: 14
    fontSize: 12
  li:
    marginTop: 4

module.exports = React.createClass
  mixins: [
    Fluxxor.FluxMixin React
  ]

  render: ->
    num = 0
    lines = util.markup @props.lines, {
      host: "#{location.protocol}//#{location.host}"
      wiki: window.page.wiki
    }

    lines = lines.map (line) =>
      list_item = do (num) =>
        indent = line.raw.match(/^(\s*)/)[0].length
        if !@props.enable or num isnt @props.editline
          <li
           key={num}
           style={ util.mix {marginLeft: indent*19}, style.li }
           onMouseDown={ => @_onClickHoldStart num }
           onMouseOut={@_onClickHoldCancel}
           onMouseUp={@_onClickHoldCancel}>
             <div dangerouslySetInnerHTML={__html: line.marked} />
          </li>
        else
          <li
           key={num}
           style={ marginLeft: indent*19 } >
            <textarea
             value={line.raw}
             style={style.input}
             ref="editlineInput"
             onChange={@_onInputChange}
             onKeyDown={@_onInputKeyDown}
             onFocus={@_onInputFocus} />
          </li>

      num += 1
      return list_item

    <ul>{lines}</ul>

  ## finish edit-mode
  componentDidMount: ->
    document.body.addEventListener 'click', @_editStop

  componentWillUnmount: ->
    document.body.removeEventListener 'click', @_editStop

  componentDidUpdate: ->
    return if typeof @props.editline isnt 'number'
    if input = React.findDOMNode @refs.editlineInput
      input.focus()
      input.addEventListener 'click', (e) -> e.stopPropagation()

  _editStop: ->
    @getFlux().actions.editor.edit false

  ## ClickHold
  _onClickHoldStart: (num) ->
    clearTimeout @clickHoldTimeoutId
    @clickHoldTimeoutId = setTimeout =>
      @getFlux().actions.editor.edit num
    , 500


  _onClickHoldCancel: (e) ->
    clearTimeout @clickHoldTimeoutId

  ## Edit
  _onInputFocus: (e) ->
    input = React.findDOMNode @refs.editlineInput
    indent = input.value.match(/^(\s*)/)[0].length
    requestAnimationFrame ->
      input.selectionStart = indent
      input.selectionEnd = indent

  _onInputChange: (e) ->
    @getFlux().actions.editor.setLine
      value: e.target.value.replace(/(^\n|\n$)/, '')
      editline: @props.editline

  _onInputKeyDown: (e) ->
    switch e.keyCode
      when 38 # up
        if e.shiftKey
          @getFlux().actions.editor.swapPrevBlock()
        else if e.metaKey or e.ctrlKey
          @getFlux().actions.editor.swapPrevLine()
        else
          @getFlux().actions.editor.editPrevLine()
      when 40 # down
        if e.shiftKey
          @getFlux().actions.editor.swapNextBlock()
        else if e.metaKey or e.ctrlKey
          @getFlux().actions.editor.swapNextLine()
        else
          @getFlux().actions.editor.editNextLine()
      when 80 # p
        if e.ctrlKey
          @getFlux().actions.editor.editPrevLine()
      when 78 # n
        if e.ctrlKey
          @getFlux().actions.editor.editNextLine()
      when 39 # right
        if e.shiftKey
          @getFlux().actions.editor.indentRight()
      when 37 # left
        if e.shiftKey
          @getFlux().actions.editor.indentLeft()
      when 13 # enter-key
        @getFlux().actions.editor.insertNewLine()
