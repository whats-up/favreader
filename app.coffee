#TODO めくらふぁぼ機能つけましょう。
year = new Date(Date.now() + 3600000*24*365)
express = require 'express'
routes = require './routes/main'
user = require './routes/user'
test_view = require './routes/test_view'
apis = require './routes/apis'
settings = require './routes/settings'
twitter_view = require './routes/twitter'
http = require 'http'
path = require 'path'
#OAuth = require('oauth').OAuth

app = express();
MongoStore = require('connect-mongo')(express)
app.configure = ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session
    secret: 'keyboard dog'
    store: new MongoStore
      db: 'favreaderdb' # require
      host: '127.0.0.1' # default: 127.0.0.1
      username: 'root' # optional
      password: 'password' # optional
    cookie:
      httpOnly: false
      expires:year
      maxAge:year
  app.use(app.router)
  app.use(require('stylus').middleware(__dirname + '/public'))
  app.use(express.static(path.join(__dirname, 'public')))

app.configure 'development', ->
  app.use express.errorHandler()


#-----------------------------------------------------------
#URL MAP
app.get '/', routes.index
app.get '/users', user.list
app.get '/test/1', test_view.test
app.get '/test/3', test_view.Mongous_test
app.get '/twitest', twitter_view.twitter_test
#API
app.get '/api/update_favorite', apis.update_favorite
app.get '/api/create_favorite', apis.create_favorite
app.get '/api/rate_limit', twitter_view.rate_limit


  #aouth
  #auth/twitterにアクセスするとTwitterアプリケーション認証画面に遷移します。
app.get('/auth/twitter', twitter_view.auth_twitter)
app.get('/auth/twitter/callback', twitter_view.auth_twitter_callback)
# app.get '*', routes.index
app.get '/dtest',twitter_view.Deferred_test
#-----------------------------------------------------------
http.createServer(app).listen app.get('port') , ->
  console.log(__dirname)
  console.log "Express server listening on port " + app.get('port')
  return