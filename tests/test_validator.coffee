'use strict'

path = require 'path'
require path.resolve 'tests', 'test_helper'

assert    = require 'assert'
request   = require 'supertest'
validator = require path.resolve 'libs/validator'

describe 'validator', ->

  it 'should have method "isWikiName"', ->
    assert.equal typeof validator.isWikiName, 'function'

  describe 'method "isWikiName"', ->
    it 'should return true if WikiName is valid', ->
      assert.equal validator.isWikiName('test'), true
      assert.equal validator.isWikiName("123"), true

    it 'should return false if WikiName includes "/"', ->
      assert.equal validator.isWikiName('test/'), false
      assert.equal validator.isWikiName('/test'), false
      assert.equal validator.isWikiName('te/st'), false

    it 'should return false if WikiName is not String', ->
      assert.equal validator.isWikiName(''), false
      assert.equal validator.isWikiName(123), false
      assert.equal validator.isWikiName(null), false

    it 'should return false if WikiName is using Reserved name', ->
      assert.equal validator.isWikiName("__api"), false

  it 'should have method "isPageTitle"', ->
    assert.equal typeof validator.isPageTitle, 'function'

  describe 'method "isPageTitle"', ->
    it 'should return true if PageTitle is valid', ->
      assert.equal validator.isPageTitle('test'), true
      assert.equal validator.isPageTitle('te/st'), true
      assert.equal validator.isPageTitle("123"), true
      assert.equal validator.isPageTitle("__api"), true

    it 'should return false if PageTitle has "/" on tail or head', ->
      assert.equal validator.isPageTitle('test/'), false
      assert.equal validator.isPageTitle('/test'), false

    it 'should return false if PageTitle is not String', ->
      assert.equal validator.isPageTitle(''), false
      assert.equal validator.isPageTitle(123), false
      assert.equal validator.isPageTitle(null), false

  it 'should have method "toValidName"', ->
    assert.equal typeof validator.toValidName, 'function'

  describe 'method "toValidName"', ->
    it 'should fix invalid wiki name & page title', ->
      assert.equal validator.toValidName('/test'), 'test'
      assert.equal validator.toValidName('test/'), 'test'
      assert.equal validator.toValidName('te/st'), 'te/st'
