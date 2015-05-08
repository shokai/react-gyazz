## Syntax Highlight

'use strict'

_    = require 'lodash'
hljs = require 'highlight.js'

langs = hljs.listLanguages()

module.exports =

  getIndentLevel: (line) ->
    line.match(/^(\s*)/)[0].length


  highlightCode: (lang, code) ->
    hljs
      .highlight lang, code.join '\n'
      .value
      .split /\n/
      .map (i) -> _.unescape i


  ## find code blocks begin with "code:lang", then highlight syntax
  findCodeBlocksAndHighlight: (lines) ->
    marked_lines = []  # markup-ed lines
    lang = null
    indent = null
    code = []
    for index, line of lines
      if (m = line.match /^\s*code:([^\s]+)/) and
         (langs.indexOf(m[1]) > -1)
        if lang isnt null and code.length > 0
          marked_lines = marked_lines.concat @highlightCode lang, code
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
            marked_lines = marked_lines.concat @highlightCode lang, code
          code = []
          lang = null
          marked_lines.push line
      else
        marked_lines.push line

    if lang isnt null and code.length > 0
      marked_lines = marked_lines.concat @highlightCode lang, code
      code = []
      lang = null

    return marked_lines
