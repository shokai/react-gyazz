## Validator
# - PageTitle
# - WikiName

_ = require 'lodash'

module.exports =
  isWikiName: (name) ->
    return false if typeof name isnt 'string'
    return false if name.length < 1
    return false if /\//.test name
    return false if /^__/.test name  # prefix "__" is reserved for system
    true

  isPageTitle: (title) ->
    return false if typeof title isnt 'string'
    return false if title.length < 1
    return false if /(^\/|\/$)/.test title
    true

  toValidName: (name) ->
    name
      .replace(/^\/+/, '')
      .replace(/\/+$/, '')

  isEmptyPageText: (text) ->
    return false if typeof text isnt 'string'
    text = @removeEmptyLines(text).join '\n'
    return text.length < 1 or text is '(empty)'
    false

  removeEmptyLines: (lines) ->
    if typeof lines is 'string'
      lines = lines.split(/[\r\n]/)
    return unless lines instanceof Array
    _.chain lines
      .map (line) -> line.replace /\s+$/, ''
      .reject (line) -> line.length < 1
      .value()
