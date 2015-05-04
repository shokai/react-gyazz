## View: Editor

React   = require 'react'
Fluxxor = require 'fluxxor'

module.exports = React.createClass
  mixins: [
    Fluxxor.FluxMixin React
  ]

  render: ->
    lines = @props.lines.map (line) ->
      <li>
        {line}
      </li>

    <ul>{lines}</ul>
