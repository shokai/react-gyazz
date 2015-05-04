## Store: Socket

Fluxxor = require 'fluxxor'

module.exports = (app) ->

  Fluxxor.createStore

    initialize: ->
      @status = 'unknown'
      @bindActions 'set-socket-status', @setState

    getState: ->
      status: @status

    setState: (@status) -> @emit 'change'
