debug    = require('debug')('gyazz:controller:main')
mongoose = require 'mongoose'
Page     = mongoose.model 'Page'


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

  router.get '/:wiki/:title', (req, res) ->
    wiki  = req.params.wiki
    title = req.params.title
    if !Page.isValidName wiki or !Page.isValidName title
      return res.status(404).end 'not found'
    Page.findOneByName
      wiki:  wiki
      title: title
    , (err, page) ->
      if err
        debug JSON.stringify err
        return res.status(500).end 'server error'
      unless page
        page = new Page
          title: title
          wiki : wiki
      args =
        page: page
        title: "#{page.wiki}::#{page.title}"
        app:
          homepage: pkg.homepage
          description: pkg.description
      return res.render 'edit', args
