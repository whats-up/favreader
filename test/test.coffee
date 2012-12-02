should = require('should');
hoge = 'fuga';
point =
	x: 10,
	y: 20
describe 'おためしtest',->
  it "1+1=2f",->
    should.equal(1+1,2)
  it '1秒待つ',(done)->
    setTimeout ->
      should.equal(1,1)
      done()
    ,1000
  it "1+1=4",->
    should.equal(1+1,2)
hoge.should.equal('fuga');
point.should.have.property('x', 10);
point.should.have.property('y', 20);
point.should.not.have.property('z');

describe 'API twitter関係',->
  it "1+1=2f",->
    should.equal(1+1,2)
  it "SET twitterからFAVを取得してDBに格納"
  it "GET クライアントにDBのデータをレスポンス"