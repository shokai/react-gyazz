## Store: Page

Fluxxor = require 'fluxxor'

module.exports = (app) ->

  Fluxxor.createStore

    initialize: ->
      @lines = window.lines or ['(empty)']

    getState: ->
      lines: @lines
