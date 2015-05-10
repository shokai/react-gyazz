'use strict'

path = require 'path'
require path.resolve 'tests', 'test_helper'

assert   = require 'assert'
request  = require 'supertest'
app      = require path.resolve 'server/app.coffee'


describe 'Server', ->

  it 'sohuld have index page', (done) ->
    request app
    .get '/'
    .expect 200
    .expect 'Content-Type', /text/
    .end done

