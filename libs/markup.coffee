# Gyazz markup
'use strict'

_ = require 'lodash'

module.exports = class GyazzMarkup

  constructor: (opts) ->
    @host = opts.host
    @wiki = opts.wiki

  markup: (lines, opts={escape: true}) ->
    lines = _.escape lines if opts.escape

    lines
      .split /[\r\n]/
      .map (line) =>
        line = @url_with_image line
        line = @image line
        line = @strong line
        line = @url_with_title line
        line = @url line
        line = @wiki_link line
        line = @inner_link line
        line
      .join ('\n')

  url_with_image: (line) ->
    reg = /\[{2}(https?:\/\/[^\s]+)\s(https?:\/\/[^\s]+)\.(png|jpe?g|gif|bmp)\]{2}/gi
    if reg.test line
      line.replace reg, "<a href=\"$1\"><img src=\"$2.$3\"></a>"
    else
      line

  image: (line) ->
    reg = /\[{2,3}(https?:\/\/[^\s]+)\.(png|jpe?g|gif|bmp)\]{2,3}/gi
    if reg.test line
      line.replace reg, "<a href=\"$1.$2\"><img src=\"$1.$2\"></a>"
    else
      line

  strong: (line) ->
    reg = /\[{3}(.+)\]{3}/g
    if reg.test line
      line.replace reg, "<strong>$1</strong>"
    else
      line

  url_with_title: (line) ->
    reg = /\[{2}(https?:\/\/[^\s]+)\s(.+)\]{2}/gi
    if reg.test line
      line.replace reg, "<a href=\"$1\">$2</a>"
    else
      line

  url: (line) ->
    reg = /\[{2}(https?:\/\/[^\s]+)\]{2}/gi
    if reg.test line
      line.replace reg, "<a href=\"$1\">$1</a>"
    else
      line

  wiki_link: (line) ->
    reg = /\[{2}([^\/]+)::(.+)\]{2}/
    if reg.test line
      line.replace reg, "<a href=\"#{@host}/$1/\">$1</a>::<a href=\"#{@host}/$1/$2\">$2</a>"
    else
      line

  inner_link: (line) ->
    reg = /\[{2}(.+)\]{2}/
    if reg.test line
      line.replace reg, "<a href=\"#{@host}/#{@wiki}/$1\">$1</a>"
    else
      line
