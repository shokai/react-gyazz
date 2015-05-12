## Validator
# - PageTitle
# - WikiName

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
    return text is null or
           text.length < 1 or
           text is '(empty)'
