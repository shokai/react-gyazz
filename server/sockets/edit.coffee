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

    room = "#{wiki}/#{title}"
    debug "new connection  #{room}"
    socket.join room
    socket.once 'disconnect', ->
      socket.leave room

    socket.on 'pagedata', (page) ->
      debug "write #{wiki}/#{title}"
      Page.write
        wiki:  wiki
        title: title
        text:  page.text
      socket.broadcast.to(room).emit 'pagedata', page
