## View utilities

_ = require 'lodash'

GyazzMarkup = require '../../libs/markup'
highlight   = require '../../libs/highlight'

module.exports =

  ## mix objects
  mix: ->
    args = Array.prototype.splice.call arguments, 0
    _.assign.apply @, [{}].concat args

  ## syntax highlight, gyazz markup
  markup: (lines, opts) ->
    gmark = new GyazzMarkup opts
    highlighted_lines = highlight.findCodeBlocksAndHighlight lines

    for index, highlighted of highlighted_lines
      raw = lines[index]
      if raw is highlighted
        marked = gmark.markup raw
      else
        marked = highlighted
      raw: raw
      marked: marked


