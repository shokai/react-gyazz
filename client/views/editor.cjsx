## View: Editor

React   = require 'react'
Fluxxor = require 'fluxxor'

mix = require('./util').mix

style =
  input:
    width: '80%'


GyazzMarkup = require '../../libs/markup'
markup = new GyazzMarkup
  host: 'http://gyazz.masuilab.org'
  wiki: '増井研'

clickHoldTimeoutId = null

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
    React
      .findDOMNode @refs.editlineInput
      .focus()

  _editStop: ->
    @getFlux().actions.editor.edit false

  ## ClickHold
  _onClickHoldStart: (num) ->
    clearTimeout clickHoldTimeoutId
    clickHoldTimeoutId = setTimeout =>
      @getFlux().actions.editor.edit num
    , 500


  _onClickHoldCancel: (e) ->
    clearTimeout clickHoldTimeoutId

  ## Edit
  _onInputChange: (e) ->
    @getFlux().actions.editor.setLine
      value: e.target.value
      editline: @props.editline

  _onInputKeyDown: (e) ->
    switch e.keyCode
      when 38 # up
        @getFlux().actions.editor.editPrevLine()
      when 40 # down
        @getFlux().actions.editor.editNextLine()
      when 80 # p
        if e.ctrlKey
          @getFlux().actions.editor.editPrevLine()
      when 78 # n
        if e.ctrlKey
          @getFlux().actions.editor.editNextLine()
      when 13 # enter-key
        @getFlux().actions.editor.insertNewLine @props.editline+1
