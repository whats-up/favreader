db=require("mongous").Mongous
myClass="mogous_test.myClass"
dbmc=db("mogous_test.myClass")
exports.Mongous_test = (req, res) ->
  ann={name:"ann",age:52,ID:1,birthday:'tomorrow'}
  bob={name:"bob",age:22,ID:2,birthday:'Unknown'}
  cally={name:"cally",age:18,ID:3,birthday:'Unknown'}
  deen={name:"deen",age:48,ID:4,birthday:'today'}
  edy={name:"edy",age:19,ID:5,birthday:'today'}

#  db("mogous_test.myClass").remove({})
#  db("mogous_test.myClass").insert(ann)
#  db("mogous_test.myClass").update({ID:ann.ID},{$inc:{age:1}},true)
#  db("mogous_test.myClass").update(ann)
#  console.log(d)
#  db("mogous_test.myClass").update({ID:ann.ID},ann,true)
  db(myClass).find {},(data)->
    res.send data
exports.test = (req,res) ->
    x=100000
    y=100000
    i = 0
    setTimeout (a = ->
      return  unless i < 3
      console.log "a" + i
      i++

      setTimeout a,1000
    ), 1
    res.send("ok")
