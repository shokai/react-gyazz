## Model: Page

debug    = require('debug')('gyazz:models:page')
_        = require 'lodash'
mongoose = require 'mongoose'

module.exports = (app) ->

  isValidName = (name) ->
    if typeof name isnt 'string'
      return false
    if name.length < 1
      return false
    if /(^\/|\/$)/.test name
      return false
    return true

  toValidName = (name) ->
    return name.replace(/^\/+/, '').replace(/\/+$/, '')

  isEmptyPageText = (text) ->
    return false if typeof text isnt 'string'
    return text is null or
           text.length < 1 or
           text is '(empty)'

  pageSchema = new mongoose.Schema
    wiki:
      type: String
      validate: [isValidName, 'Invalid WiKi name']
    title:
      type: String
      validate: [isValidName, 'Invalid Page title']
    text:
      type: String
      default: '(empty)'
    timestamp:
      type: Date
      default: -> Date.now()

  pageSchema.statics.isValidName = isValidName
  pageSchema.statics.toValidName = toValidName

  pageSchema.methods.isEmpty = ->
    return isEmptyPageText @text

  pageSchema.statics.findOneByName = (wiki, title, callback) ->
    if !isValidName(wiki) or
       (!(title instanceof RegExp) and !isValidName(title))
      callback "invalid name wiki:#{wiki}, title:#{title}"
      return

    debug "get page #{wiki}/#{title}"

    @findOne
      wiki: wiki
      title:title
    .exec (err, result) ->
      callback err, result

  mongoose.model 'Page', pageSchema
