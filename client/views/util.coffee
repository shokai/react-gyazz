## View utilities

_    = require 'lodash'
highlighter = require 'highlight.js'

GyazzMarkup = require '../../libs/markup'

module.exports =

  ## mix objects
  mix: ->
    args = Array.prototype.splice.call arguments, 0
    _.assign.apply @, [{}].concat args

  getIndentLevel: (line) ->
    line.match(/^(\s*)/)[0].length

  highlight: (lang, lines) ->
    highlighter
      .highlight lang, lines.join '\n'
      .value
      .split /\n/
      .map (i) -> _.unescape i

  markup: (lines, opts) ->

    gmark = new GyazzMarkup opts

    marked_lines = []  # markup-ed lines
    lang = null
    indent = null
    code = []
    for index, line of lines
      if (m = line.match /^\s*code:([^\s]+)/) and
         (highlighter.listLanguages().indexOf(m[1]) > -1)
        if lang isnt null and code.length > 0
          marked_lines = marked_lines.concat @highlight lang, code
        lang = m[1]
        indent = @getIndentLevel line
        code = []
        marked_lines.push line
        continue
      if lang isnt null
        if indent < @getIndentLevel(line)
          code.push line
        else
          if code.length > 0
            marked_lines = marked_lines.concat @highlight lang, code
          code = []
          lang = null
          marked_lines.push line
      else
        marked_lines.push line

    if lang isnt null and code.length > 0
      marked_lines = marked_lines.concat @highlight lang, code
      code = []
      lang = null

    res = []
    for index, marked of marked_lines
      raw = lines[index]
      if marked is raw
        marked = gmark.markup raw
      res.push {raw: raw, marked: marked}

    return res
