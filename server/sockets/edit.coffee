debug    = require('debug')('gyazz:sockets:edit')
mongoose = require 'mongoose'

Page = mongoose.model 'Page'

module.exports = (router) ->
  io = router.get 'socket.io'

  io.on 'connection', (socket) ->
    debug 'new connection'

    socket.on 'pagedata', (page) ->
      debug "write #{page.wiki}/#{page.title}"
      Page.write page.wiki, page.title, page.text
