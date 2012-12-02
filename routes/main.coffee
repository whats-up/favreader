twitter_keys = require('./settings').twitter_keys
settings = require('./settings')
twitter = require('ntwitter')
db=require("mongous").Mongous
db_keys = require('./settings').db_keys


exports.index = (req, res) ->
  isLogin=if req.session?.oauth?.access_token? then true else false
  contents={}
  contents['title']='fav reader'
  contents['session']=JSON.stringify(req.session)
  myid=req.session.oauth.results.user_id
  contents['isLogin'] =isLogin
#  db("sample_db.users").save({test:"host"})

#  db("sample_db.users").find({},(data) ->
#    console.log(data))
  if isLogin
    query=
      favorite_user_id:parseInt(myid)
    db(db_keys.favorites).find(10,query,(favorites)->
      new_datas=[]
      target_length=favorites.documents.length
      fav_add_status = (_target_length)->
        # console.log favorites
        favorite=favorites.documents[_target_length-1]
        # console.log favorite
        query2=
          id:favorite.status_id
        db(db_keys.statuses).find(1,query2,(st)->
          favorite["status"]=st.documents[0]
          new_datas.push(favorite)
          _target_length--
          if _target_length==0
            contents["favorites"]=new_datas
            console.log new_datas
            res.render 'index', contents
          else
            fav_add_status(_target_length)
          )

      fav_add_status(target_length)
      )
  #     for data in datas.documents
  #       query2=
  #         id:data.status_id
  #       db(db_keys.statuses).find(1,query2,(st)->
  #         data["status"]=st.documents[0]
  #         # console.log data
  #         new_datas.push(data)
  #         )
  #     # console.log "newdatas  :"+new_datas
  #     contents["datas"]=new_datas
  #     res.render('index', contents)
  #     )


  # else
  #   console.log("not login")
  #   res.render('index', contents)
