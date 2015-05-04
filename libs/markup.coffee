# Gyazz markup

module.exports = class GyazzMarkup

  constructor: (opts) ->
    @host = opts.host
    @wiki = opts.wiki

  markup: (lines) ->
    lines
      .split /[\r\n]/
      .map (line) =>
        line = @markup_url_with_image line
        line = @markup_image line
        line = @markup_strong line
        line = @markup_url_with_title line
        line = @markup_url line
        line = @markup_wiki_link line
        line = @markup_inner_link line
        line
      .join ('\n')

  markup_url_with_image: (line) ->
    reg = /\[{2}(https?:\/\/[^\s]+)\s(https?:\/\/[^\s]+)\.(png|jpe?g|gif|bmp)\]{2}/gi
    if reg.test line
      line.replace reg, "<a href=\"$1\"><img src=\"$2.$3\"></a>"
    else
      line

  markup_image: (line) ->
    reg = /\[{2,3}(https?:\/\/[^\s]+)\.(png|jpe?g|gif|bmp)\]{2,3}/gi
    if reg.test line
      line.replace reg, "<a href=\"$1.$2\"><img src=\"$1.$2\"></a>"
    else
      line

  markup_strong: (line) ->
    reg = /\[{3}(.+)\]{3}/g
    if reg.test line
      line.replace reg, "<strong>$1</strong>"
    else
      line

  markup_url_with_title: (line) ->
    reg = /\[{2}(https?:\/\/[^\s]+)\s(.+)\]{2}/gi
    if reg.test line
      line.replace reg, "<a href=\"$1\">$2</a>"
    else
      line

  markup_url: (line) ->
    reg = /\[{2}(https?:\/\/[^\s]+)\]{2}/gi
    if reg.test line
      line.replace reg, "<a href=\"$1\">$1</a>"
    else
      line

  markup_wiki_link: (line) ->
    reg = /\[{2}([^\/]+)::(.+)\]{2}/
    if reg.test line
      line.replace reg, "<a href=\"#{@host}/$1/\">$1</a>::<a href=\"#{@host}/$1/$2\">$2</a>"
    else
      line

  markup_inner_link: (line) ->
    reg = /\[{2}(.+)\]{2}/
    if reg.test line
      line.replace reg, "<a href=\"#{@host}/#{@wiki}/$1\">$1</a>"
    else
      line
