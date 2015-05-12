'use strict'

path = require 'path'
require path.resolve 'tests', 'test_helper'

assert   = require 'assert'
request  = require 'supertest'
mongoose = require 'mongoose'
app      = require path.resolve 'server/app'

describe 'model "Page"', ->

  Page = mongoose.model 'Page'

  it 'should have method "findOneByName"', ->
    assert.equal typeof Page.findOneByName, 'function'

  it 'should have method "write"', ->
    assert.equal typeof Page.write, 'function'


  describe 'method "write" and "findOneByName"', ->

    it 'should save page data', (done) ->
      text = new Date().toString()
      Page.write
        wiki:  'testwiki'
        title: 'testpage'
        text: text
      , (err) ->
        console.error err if err
        Page.findOneByName
          wiki:  'testwiki'
          title: 'testpage'
        , (_err, page) ->
          console.error _err if _err
          assert.equal page.title, 'testpage'
          assert.equal page.wiki, 'testwiki'
          assert.equal page.text, text
          done()
