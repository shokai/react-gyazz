## View: Editor

React   = require 'react'
Fluxxor = require 'fluxxor'

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
      html = markup.markup line
      num += 1
      do (num) =>
        <li
         dangerouslySetInnerHTML={ __html: html }
         key={num}
         onMouseDown={ => @_onClickHoldStart num-1 }
         onMouseOut={@_onClickHoldCancel}
         onMouseUp={@_onClickHoldCancel} />

    <ul>{lines}</ul>

  _onClickHoldStart: (num) ->
    console.log "hold start"
    clearTimeout clickHoldTimeoutId
    clickHoldTimeoutId = setTimeout ->
      console.log "edit start #{num}"
    , 500


  _onClickHoldCancel: (e) ->
    console.log 'hold cancel'
    clearTimeout clickHoldTimeoutId
