const express = require('express')
const actions = require('../methods/actions')
const router = express.Router()
//var Vin = require('../models/vin')
//var User = require('../models/user')

router.get('/dashboard', (req, res) => {
    res.send('Dashboard')
})

// a chaque route, on a une fonction http a exec coté client flutter

router.post('/name', actions.lookForName)
//router.post('/searchvin', actions.lookForVinTitle)
router.post('/addcom', actions.addComment)
router.post('/addlike', actions.addLike)
router.post('/infovin', actions.lookForAllDataVin)

//@desc Adding new user
//@route POST /adduser
router.post('/adduser', actions.addNew)

//@desc Authenticate a user
//@route POST /authenticate
router.post('/authenticate', actions.authenticate)

//@desc Get info on a user
//@route GET /getinfo
router.get('/getinfo', actions.getinfo)

router.get('/home', function(req, res) {

    Vin.find({ }).then((allvin) => {

      data = allvin;

      User.find({ }).then((alluser) => {
        datauser = alluser;

        res.render("home.html", 
          {data: data,  error: false, datauser: datauser}
        );
          console.log(allvin)
      })
    })
    //res.sendFile('/Users/sebastien/Desktop/M1 Informatique/Urbanisation/ShazamTest/list.ejs');
});

router.get('/', function(req, res){
    //res.render('index.html',{email:"ook",password:"okok"});
    res.sendFile('/Users/sebastien/Desktop/M1 Informatique/Urbanisation/ShazamTest/index.html');
});

//delete dataVin by id 
router.get('/deletevin/(:id)', function (req, res, next) {
    Vin.findByIdAndRemove(req.params.id, (err, doc) => {
      if (!err) {
        res.redirect('/home')
      } else {
        console.log(err)
      }
    })
  })

  router.get('/deleteuser/(:id)', function (req, res, next) {
    User.findByIdAndRemove(req.params.id, (err, doc) => {
      if (!err) {
        res.redirect('/home')
      } else {
        console.log(err)
      }
    })
  })

  router.get('/deletecomm/(:idcom)/(:id)', function (req, res, next) {
    Vin.updateOne(
      { _id: req.params.id },
      
          {$pull: {
            comments: {
              _id: req.params.idcom
            }
          }
      }
      
  , (err, doc) => {
      if (!err) {
        res.redirect('/home')
      }
        
      else {
        console.log(err)
      }
      
    });

  })
    

  

module.exports = router