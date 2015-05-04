## View: Editor

React   = require 'react'
Fluxxor = require 'fluxxor'

GyazzMarkup = require '../../libs/markup'
markup = new GyazzMarkup
  host: 'http://gyazz.masuilab.org'
  wiki: '増井研'

module.exports = React.createClass
  mixins: [
    Fluxxor.FluxMixin React
  ]

  render: ->
    key = 0
    lines = @props.lines.map (line) ->
      html = markup.markup line
      <li dangerouslySetInnerHTML={ __html: html } key={key++}>
      </li>

    <ul>{lines}</ul>
