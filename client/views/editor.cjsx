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
        if num isnt @props.editline
          gyazz_html = markup.markup line
          <li
           key={num}
           onMouseDown={ => @_onClickHoldStart num }
           onMouseOut={@_onClickHoldCancel}
           onMouseUp={@_onClickHoldCancel}>
             <div dangerouslySetInnerHTML={__html: gyazz_html} />
          </li>
        else
          <li key={num}>
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
        if @props.editline > 0
          @getFlux().actions.editor.edit @props.editline-1
      when 40 # down
        if @props.editline < @props.lines.length-1
          @getFlux().actions.editor.edit @props.editline+1
