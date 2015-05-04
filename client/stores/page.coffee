## Store: Page

Fluxxor = require 'fluxxor'

module.exports = (app) ->

  Fluxxor.createStore

    initialize: ->
      @lines = window.lines or ['shokai', 'testtest']

    getState: ->
      lines: @lines
