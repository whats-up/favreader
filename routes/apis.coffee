twitter = require('ntwitter');
db = require("mongous").Mongous
twitter_keys = require('./settings').twitter_keys
db_keys = require('./settings').db_keys
# db_name = 'favr_db'
# db_statuses = "#{db_name}.statuses"
# db_users = "#{db_name}.users"
# db_favorites = "#{db_name}.favorites"
$ = require('jQuery')

#Mongolian set -----------------------------

Mongolian = require("mongolian")
server = new Mongolian
lian = server.db("favr_db")
favorites = lian.collection('favorites')
statuses = lian.collection('statuses')
users = lian.collection('users')

# end Mongolian ------------------------------
class Favorite
  constructor:(status_id,favorite_user_id) ->
    this.status_id=status_id
    this.favorite_user_id=favorite_user_id
    this.color=111
    this.point=1
    this.ext=1

exports.update_favorite = (req, res) ->
  isLogin=if req.session?.oauth?.access_token? then true else false

  if isLogin
    get_since_id(req).done((cb)->
      list = []
      for i in cb
        list.push(i.bom)
      console.log list
      res.send(list)
      )


exports.create_favorite =  (req,res)->
  isLogin=if req.session?.oauth?.access_token? then true else false
  min_id=false
  data=false
  if isLogin
    myid = parseInt(req.session.oauth.results.user_id)
    twit = new twitter
      consumer_key: twitter_keys.consumer_key
      consumer_secret: twitter_keys.consumer_secret
      access_token_key: req.session.oauth.access_token
      access_token_secret: req.session.oauth.access_token_secret

    ajax_loop = ->
      twiToDb(min_id,twit,myid).done((cb)->
        console.log "start"
        datas=cb

        console.log datas[0]["id"]
        for data in datas
          if min_id>data["id"] or min_id == false
            min_id=data["id"]
        ajax_loop()
        ).fail((err)->
            console.log "error"
            res.send(err)
        )
    ajax_loop()
    #while_ver
    # AAA:while true
    #   state=twiToDb(min_id,twit).done((cb)->
    #     console.log "start"
    #     data=cb
    #     console.log data[0]["id"]


    #     )
    #   console.log state.state()
    #   if state.state()=="pending"
    #     break
    #   else
    #     continue
    #while_ver end



    # $.each(arr,->
    #   twiToDb(min_id,twit).done((data)->
    #     data=data
    #     console.log data[0]["id"]
    #     min_id=data[0]["id"]
    #     )
    #   console.log "next"
    #   )
    # teststs=twiToDb(false,twit)
    # teststs.done((cb)->
    #   console.log "end"
    #   data=cd
    #   )


  # else
  #   console.log("not login")
  #   res.send("{result:'not login error'}")

twiToDb = (min_id,twit,myid)->
  console.log("loop #{min_id} done..." )
  opt={count:100}
  if min_id
    opt["max_id"]=min_id
  dfd = new $.Deferred()
  twit.get(
    "https://api.twitter.com/1.1/favorites/list.json"
    opt
    (err,data) ->
      if data
        DbAddData(data,myid)
        dfd.resolve(data)
      else
        dfd.reject({error:"no data"})
  )
  return dfd.promise()

DbAddData = (data,myid)->
  for j in data
    status = j
    user = status.user
    fav = new Favorite(status.id,myid)
    db(db_statuses).update({"id":j.id},status,true)
    db(db_users).update({"id":user.id},user,true)
    db(db_favorites).update({"status_id":j.id},fav,true)
    if min_id == false or min_id > j.id then min_id=j.id
  return
get_since_id = (req)->
  dfd = new $.Deferred()
  myid = parseInt(req.session.oauth.results.user_id)

  favorites.find({},{bom:1}).limit(5).sort({ bom: 1 }).toArray((err, array) ->
  # sample.findOne({},(err,data)->
    if err
      console.log "err"
      return dfd.reject({error:"no data"})
    else
      console.log server
      # server.shutdownServer()
      return dfd.resolve(array)
    )

  return dfd.promise()
get_since_id_back = (req)->
  dfd = new $.Deferred()
  myid = parseInt(req.session.oauth.results.user_id)
  query =
    favorite_user_id:myid
  # db(db_keys.favorites).find(query, 1,{},{sort:{status_id:1}},(favorites)->
  db("test.sample").find({bom:{$gt:33}}, 4,{},{sort:{bom:77},limit:4},(favorites)->
    return dfd.resolve(favorites)
    )
  return dfd.promise()