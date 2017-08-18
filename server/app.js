var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var request = require('request');
var config = require('./config');
var eachAsync = require('each-async');
var cors = require('cors');

app.use(cors());
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))

app.listen(3000, ()=> {
  console.log('start 3000port!')
})

app.post('/shops', (req, res)=> {
  var shops = {}
  var shopArray = []
  config.getToken(()=> {
    eachAsync(config.categoryList, function(category, index, done) {
      request({
        url: config.standardUrl+'/v2/shops?size=2000',
        method: 'POST',
        json: true,
        headers: {
          'Authorization': 'Bearer '+config.token
        },
        body: {
          'lat': req.body.lat,
          'lng': req.body.lng,
          'category': category
        }
      }, function(err, res, body) {
        shopArray = shopArray.concat(body.content)
        shops[category] = body.content
        done()
      })
    }, function(err) {
      if(err) throw err;
      if(req.body.type === 1) {
        res.json({shops: shops, shopArray: shopArray})
      } else {
        res.json(shopArray)
      }
    })
  })
})

app.get('/menu/:shopNo', (req, response)=> {
  console.log("ddddd")
  var shopNo = req.params.shopNo
  var menu = {}
  config.getToken(()=> {
    request({
      url: config.standardUrl+'/v1/shops/'+shopNo+'/foods-groups',
      method: 'GET',
      json: true,
      headers: {
        'Authorization': 'Bearer '+config.token
      }
    }, function(err, res, body) {

      eachAsync(body, function(group, index, done) {
        request({
          url: config.standardUrl+'/v1/shops/'+shopNo+'/foods?size=2000',

          method: 'GET',
          json: true,
          headers: {
            'Authorization': 'Bearer '+config.token
          },
          parameters: {
            'shopFoodGrpSeq': group
          }
        }, function(err, res, body) {
          menu[group.shopFoodGrpNm] = body.content
          done()
        })
      }, function(err) {
        if(err) throw err;
        else {
          console.log(menu)
          response.json(menu)
        }
      })
    })
  })
})
