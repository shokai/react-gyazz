## Model: Page

_debug = require('debug')('gyazz:models:page')
debug  = (msg) ->
  _debug msg
  return msg

_        = require 'lodash'
mongoose = require 'mongoose'
memjs    = require 'memjs'
cache    = memjs.Client.create null, {expire: 60}

module.exports = (app) ->

  pkg = app.get 'package'

  isValidWikiName = (name) ->
    return false if typeof name isnt 'string'
    return false if name.length < 1
    return false if /\//.test name
    return false if /^__/.test name  # prefix "__" is reserved for system
    true

  isValidPageTitle = (name) ->
    return false if typeof name isnt 'string'
    return false if name.length < 1
    return false if /(^\/|\/$)/.test name
    true

  toValidName = (name) -> name.replace(/^\/+/, '').replace(/\/+$/, '')

  isEmptyPageText = (text) ->
    return false if typeof text isnt 'string'
    return text is null or
           text.length < 1 or
           text is '(empty)'

  cache.createKey = (wiki, title) -> "#{pkg.name}::page::#{wiki}/#{title}"


  pageSchema = new mongoose.Schema
    wiki:
      type: String
      validate: [isValidWikiName, 'Invalid WiKi name']
    title:
      type: String
      validate: [isValidPageTitle, 'Invalid Page title']
    text:
      type: String
      default: '(empty)'
    created_at:
      type: Date
      default: -> Date.now()
    updated_at:
      type: Date
      default: -> Date.now()

  pageSchema.statics.isValidWikiName  = isValidWikiName
  pageSchema.statics.isValidPageTitle = isValidPageTitle
  pageSchema.statics.toValidName = toValidName

  pageSchema.methods.isEmpty = ->
    return isEmptyPageText @text

  pageSchema.methods.toHash = ->
    wiki:  @wiki
    title: @title
    text:  @text

  # Options:
  #   cache: false => disable cache
  pageSchema.statics.findOneByName = (opts = {wiki: null, title: null} , callback) ->
    wiki  = opts.wiki
    title = opts.title
    if !isValidWikiName(wiki) or
       (!(title instanceof RegExp) and !isValidPageTitle(title))
      return callback debug "invalid name wiki:#{wiki}, title:#{title}"

    if opts.cache is false
      @findOne
        wiki:  wiki
        title: title
      .exec callback
      return

    key = cache.createKey wiki, title
    cache.get key, (err, cached_text, flag) =>
      if err
        debug "cache get Error - #{err}"
      if !err and cached_text?
        debug "get page #{wiki}/#{title} - cache hit"
        page = new @
          wiki: wiki
          title: title
          text: decodeURI cached_text
        return callback null, page

      debug "get page #{wiki}/#{title}"
      @findOne
        wiki:  wiki
        title: title
      .exec callback


  pageWriteTimeouts = {}
  pageSchema.statics.write = (opts, callback = ->) ->
    wiki  = opts.wiki
    title = opts.title
    text  = opts.text
    if typeof text isnt 'string'
      return callback debug "invalid text"

    if !isValidWikiName(wiki) or
       (!(title instanceof RegExp) and !isValidPageTitle(title))
      return callback debug "invalid name wiki:#{wiki}, title:#{title}"

    key = cache.createKey wiki, title
    cache.set key, encodeURI(text), (err, val) =>
      wait = 20000  # 20sec
      if err
        debug "cache set Error - #{err}"
        wait = 10
      if isEmptyPageText text
        wait = 1

      clearTimeout pageWriteTimeouts[key]
      pageWriteTimeouts[key] = setTimeout =>

        @findOneByName
          wiki:  wiki
          title: title
          cache: false
        , (err, page) =>
          return callback debug err if err

          unless page
            page = new @ {wiki:wiki, title:title}

          page.text = text
          page.updated_at = Date.now()
          page.save (err, data) ->
            if err
              return callback debug err
            debug "saved #{wiki}/#{title}"
      , wait

      callback()

  mongoose.model 'Page', pageSchema
