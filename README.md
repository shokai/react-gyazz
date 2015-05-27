React Gyazz
===========
Gyazz style Wiki implement with Ract and Fluxxor

- [demo](https://react-gyazz.herokuapp.com/)
- [source code](https://github.com/shokai/react-gyazz)

[![Circle CI](https://circleci.com/gh/shokai/react-gyazz.svg?style=svg)](https://circleci.com/gh/shokai/react-gyazz)
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

- coffee-script
- express 4.12.x
- socket.io 1.3.x
- React + Fluxxor + Browserify
- mongoose + connect-mongo
- jade
- grunt + coffeelint + mocha + supertest
- Heroku
- Travis CI


REQUIREMENTS
------------

- Node.js v0.12.x
- MongoDB v2.x
- Memcached


BUILD CLIENT-JS&JSX
---------------

    % npm install
    % npm run build

    # watch client jsx, then build
    % npm run watchify

    # to deploy, minify js
    % NODE_ENV=production npm run build

RUN
---

    # start server at port:3000
    % PORT=3000 DEBUG=gyazz* npm start


TEST & LINT
-----------

    % npm test


DEPLOY
------

### create app

    % heroku apps:create react-gyazz
    % git push heroku master

### config

    % heroku config:add TZ=Asia/Tokyo
    % heroku config:set "DEBUG=gyazz*"
    % heroku config:set NODE_ENV=production

### enable MongoDB plug-in

    % heroku addons:add mongolab
    # or
    % heroku addons:add mongohq

### logs

    % heroku logs --num 300
    % heroku logs --tail


DEPLOY HOOK
-----------

edit `.travis.yml`.

- deploy to Heroku when Travis CI passed
