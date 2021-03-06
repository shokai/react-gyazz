path = require 'path'

debug     = require('debug')('gyazz:sockets:edit')
mongoose  = require 'mongoose'
validator = require path.resolve 'libs/validator'

Page = mongoose.model 'Page'

module.exports = (router) ->
  io = router.get 'socket.io'

  io.on 'connection', (socket) ->
    wiki  = decodeURIComponent socket.handshake.query.wiki
    title = decodeURIComponent socket.handshake.query.title
    if !validator.isWikiName(wiki) or !validator.isPageTitle(title)
      socket.disconnect()
      debug "invalid WikiName/PageTitle #{wiki}/#{title}"
      return

    room = "#{wiki}/#{title}"
    debug "new connection  #{room}"
    socket.join room
    socket.once 'disconnect', ->
      socket.leave room

    Page.findOneByName
      wiki:  wiki
      title: title
    , (err, page) =>
      if err
        return res.status(500).end 'server error'
      unless page
        page = new Page
          title: title
          wiki : wiki
      socket.emit 'pagedata', page.toHash()

      socket.on 'pagedata', (page) ->
        debug "write #{wiki}/#{title}"
        Page.write
          wiki:  wiki
          title: title
          text:  page.text
        socket.broadcast.to(room).emit 'pagedata', page
