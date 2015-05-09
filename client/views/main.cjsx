## View: Main

React   = require 'react'
Fluxxor = require 'fluxxor'

Editor = require './editor'

module.exports = React.createClass
  mixins: [
    Fluxxor.FluxMixin React
    Fluxxor.StoreWatchMixin 'Socket', 'Page'
  ]

  getStateFromFlux: ->
    socket: @getFlux().store('Socket').getState()
    page:   @getFlux().store('Page').getState()

  render: ->
    <div>
      <h1>{page.title}</h1>
      <div>socket.io: {@state.socket.status}</div>
      <Editor
       lines={@state.page.lines}
       editline={@state.page.editline}
       enable={@state.page.enable} />
    </div>
