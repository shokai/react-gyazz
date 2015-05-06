## View: Editor

React   = require 'react'
Fluxxor = require 'fluxxor'

mix = require('./util').mix

style =
  input:
    width: '80%'


GyazzMarkup = require '../../libs/markup'
markup = new GyazzMarkup
  host: "#{location.protocol}//#{location.host}"
  wiki: window.page.wiki

module.exports = React.createClass
  mixins: [
    Fluxxor.FluxMixin React
  ]

  render: ->
    num = 0
    lines = @props.lines.map (line) =>
      list_item = do (num) =>
        indent = line.match(/^(\s*)/)[0].length
        if num isnt @props.editline
          gyazz_html = markup.markup line
          <li
           key={num}
           style={ {marginLeft: indent*20} }
           onMouseDown={ => @_onClickHoldStart num }
           onMouseOut={@_onClickHoldCancel}
           onMouseUp={@_onClickHoldCancel}>
             <div dangerouslySetInnerHTML={__html: gyazz_html} />
          </li>
        else
          <li
           key={num}
           style={ marginLeft: indent*20 } >
            <input
             value={line}
             style={style.input}
             ref="editlineInput"
             onChange={@_onInputChange}
             onKeyDown={@_onInputKeyDown} />
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
  _onInputChange: (e) ->
    @getFlux().actions.editor.setLine
      value: e.target.value
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
