## View: Main

React   = require 'react'
Fluxxor = require 'fluxxor'

module.exports = React.createClass
  mixins: [
    Fluxxor.FluxMixin React
    Fluxxor.StoreWatchMixin 'Page', 'Socket'
  ]

  getStateFromFlux: ->
    page:   @getFlux().store('Page').getState()
    socket: @getFlux().store('Socket').getState()

  render: ->
    <div>
      <h1>{title}</h1>
      <div>socket.io: {@state.socket.status}</div>
    </div>
