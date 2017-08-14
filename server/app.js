var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var request = require('request');
var config = require('./config');

app.listen(3000, function() {
  console.log('start 3000port!')
})

app.get('/', function(req, res) {
  config.getToken()
  console.log(config.token)
  res.send('success')

})
