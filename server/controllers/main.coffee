debug    = require('debug')('gyazz:controller:main')
mongoose = require 'mongoose'

module.exports = (router) ->

  config = router.get 'config'
  pkg    = router.get 'package'

  router.get '/', (req, res) ->
    args =
      title: config.title
      app:
        homepage: pkg.homepage
        description: pkg.description

    return res.render 'index', args
