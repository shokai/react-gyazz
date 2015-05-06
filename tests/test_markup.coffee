'use strict'

path = require 'path'
require path.resolve 'tests', 'test_helper'

assert   = require 'assert'
request  = require 'supertest'
GyazzMarkup = require path.resolve 'libs/markup'


describe 'GyazzMarkup', ->

  markup = new GyazzMarkup
    host: 'http://gyazz.com'
    wiki: 'test'

  describe 'method "image"', ->

    it 'sohuld markup img tag png', ->
      img_url = "http://example.com/foo.png"
      assert.equal markup.image("[[#{img_url}]]")
      , "<a href=\"#{img_url}\"><img src=\"#{img_url}\"></a>"

    it 'should mrakup img tag jpg', ->
      img_url = "http://example.com/foo.jpg"
      assert.equal markup.image("[[#{img_url}]]")
      , "<a href=\"#{img_url}\"><img src=\"#{img_url}\"></a>"

    it 'should markup img tag jpeg', ->
      img_url = "http://example.com/foo.jpeg"
      assert.equal markup.image("[[#{img_url}]]")
      , "<a href=\"#{img_url}\"><img src=\"#{img_url}\"></a>"

    it 'should markup img tag bmp', ->
      img_url = "http://example.com/foo.bmp"
      assert.equal markup.image("[[#{img_url}]]")
      , "<a href=\"#{img_url}\"><img src=\"#{img_url}\"></a>"

    it 'should markup img tag gif', ->
      img_url = "http://example.com/foo.gif"
      assert.equal markup.image("[[#{img_url}]]")
      , "<a href=\"#{img_url}\"><img src=\"#{img_url}\"></a>", 'gif image'

    it 'should not markup invalid img format', ->
      img_url = "http://example.com/foo.baaarrr"
      assert.equal markup.image("[[#{img_url}]]")
      , "[[#{img_url}]]"

  describe 'method "url"', ->

    it 'should markup HTTP URL', ->
      url = "http://example.com"
      assert.equal markup.url("[[#{url}]]")
      , "<a href=\"#{url}\">#{url}</a>"

    it 'should markup HTTPS URL', ->
      url = "https://example.com"
      assert.equal markup.url("[[#{url}]]")
      , "<a href=\"#{url}\">#{url}</a>"

    it 'should not markup FTP', ->
      url = "ftp://example.com"
      assert.equal markup.url("[[#{url}]]")
      , "[[#{url}]]"

  describe 'method "inner_link"', ->

    it 'should markup inner link', ->
      assert.equal markup.inner_link("[[foo bar]]")
      , "<a href=\"http://gyazz.com/test/foo bar\">foo bar</a>"


  describe 'method "wiki_link"', ->

    it 'should markup wiki link', ->
      assert.equal markup.wiki_link("[[WikiName::PageName]]")
      , "<a href=\"http://gyazz.com/WikiName/\">WikiName</a>::<a href=\"http://gyazz.com/WikiName/PageName\">PageName</a>"

    it 'should markup space separated wiki link', ->
      assert.equal markup.wiki_link("[[Wiki Name::Page Name]]")
      , "<a href=\"http://gyazz.com/Wiki Name/\">Wiki Name</a>::<a href=\"http://gyazz.com/Wiki Name/Page Name\">Page Name</a>"


  describe 'method "strong"', ->

    it 'should markup strong tag', ->
      assert.equal markup.strong("[[[foo]]]")
      , "<strong>foo</strong>"

    it 'should markup space separated strong tag', ->
      assert.equal markup.strong("[[[foo bar baz]]]")
      , "<strong>foo bar baz</strong>"

  describe 'method "url_with_title"', ->

    it 'should markup URL with Title', ->
      assert.equal markup.url_with_title("[[http://example.com mypage]]")
      , "<a href=\"http://example.com\">mypage</a>"

    it 'should markup space in title', ->
      assert.equal markup.url_with_title("[[http://example.com my great page]]")
      , "<a href=\"http://example.com\">my great page</a>", "space in title"

  describe 'method "url_with_image"', ->

    it 'should markup URL with png image', ->
      img_url = "http://example.com/foo.png"
      url = "http://example.com"
      assert.equal markup.url_with_image("[[#{url} #{img_url}]]")
      , "<a href=\"#{url}\"><img src=\"#{img_url}\"></a>"

    it 'should markup URL with jpg image', ->
      img_url = "http://example.com/foo.jpg"
      url = "http://example.com"
      assert.equal markup.url_with_image("[[#{url} #{img_url}]]")
      , "<a href=\"#{url}\"><img src=\"#{img_url}\"></a>"

    it 'should markup URL with jpeg image', ->
      img_url = "http://example.com/foo.jpeg"
      url = "http://example.com"
      assert.equal markup.url_with_image("[[#{url} #{img_url}]]")
      , "<a href=\"#{url}\"><img src=\"#{img_url}\"></a>"

    it 'should markup URL with gif image', ->
      img_url = "http://example.com/foo.gif"
      url = "http://example.com"
      assert.equal markup.url_with_image("[[#{url} #{img_url}]]")
      , "<a href=\"#{url}\"><img src=\"#{img_url}\"></a>", "url with gif image"

    it 'should markup URL with bmp image', ->
      img_url = "http://example.com/foo.bmp"
      url = "http://example.com"
      assert.equal markup.url_with_image("[[#{url} #{img_url}]]")
      , "<a href=\"#{url}\"><img src=\"#{img_url}\"></a>", "url with bmp image"

    it 'should not markup with invalid image', ->
      img_url = "http://example.com/foo.baz"
      url = "http://example.com"
      assert.equal markup.url_with_image("[[#{url} #{img_url}]]"),
      "[[#{url} #{img_url}]]"
