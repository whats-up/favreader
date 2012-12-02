OAuth = require('oauth').OAuth
twitter_keys = require('./settings').twitter_keys
twitter = require('ntwitter')
$ = require('jQuery')

#aouth
oa = new OAuth(
  "https://api.twitter.com/oauth/request_token"
  "https://api.twitter.com/oauth/access_token"
  twitter_keys.consumer_key
  twitter_keys.consumer_secret
  "1.0"
  "http://127.0.0.1:3000/auth/twitter/callback"
  "HMAC-SHA1"
)
URL_FAVORITE="https://api.twitter.com/1.1/favorites/list.json"
URL_RATE_LIMIT="https://api.twitter.com/1.1/application/rate_limit_status.json"
URL_RATE_LIMIT1="https://api.twitter.com/1/account/rate_limit_status.json"

testfunc=->
  i=0
  while true
    console.log i
    i++
    if i==5
      break

exports.auth_twitter = (req, res) ->
  console.log('start')
  oa.getOAuthRequestToken((error, oauth_token, oauth_token_secret, results) ->
    if error
      console.log('starterr')
      console.log(error)
      res.send("yeah no. didn't work.")
    else
      console.log('start2')
      req.session.oauth = {}
      req.session.oauth.token = oauth_token
      console.log('start3')
      console.log('oauth.token: ' + req.session.oauth.token)
      req.session.oauth.token_secret = oauth_token_secret
      console.log('oauth.token_secret: ' + req.session.oauth.token_secret)
      res.redirect('https://twitter.com/oauth/authenticate?oauth_token='+oauth_token)
    return)
  return

exports.auth_twitter_callback = (req, res,next) ->

  if req.session.oauth
    req.session.oauth.verifier = req.query.oauth_verifier
    oauth = req.session.oauth
    oa.getOAuthAccessToken(
      oauth.token
      oauth.token_secret
      oauth.verifier
      (error, oauth_access_token, oauth_access_token_secret, results) ->
        if (error)
          #TODO エラーページを作る
          console.log(error);
          res.send("yeah something broke.")
        else
          req.session.oauth.access_token = oauth_access_token
          req.session.oauth.access_token_secret = oauth_access_token_secret
          req.session.oauth.results = results
          console.log(req.session)
          res.redirect('/')
    )
  else
    next(new Error("you're not supposed to be here."))
    return
exports.twitter_test =(req,res)->
  testfunc()
  res.send("ok")
  #   console.log 1
  # console.log result
  # res.send result
  # else
  #    console.log 2
  # url=URL_FAVORITE
  # opt=
  #   count:100
  #   include_entities:true
  # data=twitter_conection(url,opt,req)
  # setTimeout ->
  #   console.log "send"+result
  #   res.send(result)
  # ,1
  # res.send(twitter_conection(url,opt,req))
exports.twitter_test2 =(req,res)->
  url=URL_FAVORITE
  opt=
    count:100
    since_id:269925301826494460
    max_id:269925301826494460
    include_entities:true
  twitter_conection(url,opt,req).done((data)->
    if !data
       return res.send(data)
    console.log 'test send'
    console.log data
    sid1=0
    str=0
    first=true
    for d in data
      if first
        sid1=d.id
        first=false
      else
        str+= d.id-sid1
        str+= "<br />"

        console.log d.id
        sid1=d.id
    res.send(str))
exports.rate_limit =(req,res)->
  url=URL_RATE_LIMIT
  twitter_conection(url,{},req).done((data)->
    res.send(data["resources"]["favorites"]))
twitter_conection = (url,option,req) ->
  dfd = new $.Deferred()
  twit = new twitter(
    consumer_key: twitter_keys.consumer_key
    consumer_secret: twitter_keys.consumer_secret
    access_token_key: req.session.oauth.access_token
    access_token_secret: req.session.oauth.access_token_secret
  )
  twit.get(url,option,(err,data) ->
    console.log("test4")
    dfd.resolve(data)
    )
  return dfd.promise()

exports.Deferred_test = (req,res) ->
  value = 3
  date = if value then value else 6
  console.log date
  if v = {}
      console.log "3."
      console.log v
      res.send "ok boy"
  else
      console.log "not 3."
      console.log v
      res.send "NG boy"