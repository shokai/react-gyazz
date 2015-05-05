debug    = require('debug')('gyazz:sockets:edit')
mongoose = require 'mongoose'

Page = mongoose.model 'Page'

module.exports = (router) ->
  io = router.get 'socket.io'

  io.on 'connection', (socket) ->
    wiki  = decodeURIComponent socket.handshake.query.wiki
    title = decodeURIComponent socket.handshake.query.title
    unless wiki? or title?
      socket.disconnect()
      return

    debug "new connection  #{wiki}/#{title}"

    socket.on 'pagedata', (page) ->
      debug "write #{wiki}/#{title}"
      Page.write wiki, title, page.text
