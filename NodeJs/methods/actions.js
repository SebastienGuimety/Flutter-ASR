//var User = require('../models/user')
var jwt = require('jwt-simple')
var config = require('../config/dbconfig')
//var Vin = require('../models/vin');



var functions = {
    // new user bdd
    addNew: function (req, res) {
        if ((!req.body.name) || (!req.body.password)) {
            res.json({success: false, msg: 'Enter all fields'})
            
            console.log('rempli tout stp')
        }
        else {
            var newUser = User({
                name: req.body.name,
                password: req.body.password
            });
            newUser.save(function (err, newUser) {
                if (err) {
                    res.json({success: false, msg: 'Failed to save'})
                    res.json({success: false, msg: 'Failed to save'})
                }
                else {
                    res.json({success: true, msg: 'Successfully saved'})
                }
            })
        }
    },

    // on affiche les infos du vin
    lookForAllDataVin: function (req, res) {
        console.log("la c'est l'id du vin", req.body.idvin);



        Vin.findById(req.body.idvin, function (err, allvininfos) {
            if(err) throw err;
            if(allvininfos) {
                console.log("la on trouve bien le vin", allvininfos.prix);
                console.log("la on trouve bien le vin", allvininfos.descriptif);
                res.json({
                    success: true, 
                    idvin: allvininfos._id.valueOf(),
                    name: allvininfos.name, 
                    descriptif: allvininfos.descriptif, 
                    embouteillage: allvininfos.embouteillage, 
                    nomcepage: allvininfos.nomcepage, 
                    nomchateau: allvininfos.nomchateau,
                    prix: allvininfos.prix,
                    likes:allvininfos.likes,
                    comments: allvininfos.comments
                });
            } else {
                res.json({success: false, msg: 'Probleme survenu au moment de la recuperation des donnée par node js'});
            }
        });
    },

    // on cherche le nom d'un user en fonction de son id
    lookForName: function (req, res) {
        console.log("la c'est l'id du gars", req.body.id);



        User.findById(req.body.id, function (err, alluserinfo) {
            if(err) throw err;
            if(alluserinfo) {
                res.json({
                    success: true, 
                    name: alluserinfo.name,
                });
            } else {
                res.json({success: false, msg: 'Probleme survenu au moment de la recuperation des donnée par node js'});
            }
        });
    },
  

    
    
    //authentification avec un password haché
    authenticate: function (req, res) {
        User.findOne({
            name: req.body.name
            
        }, function (err, user) {
          
                console.log("name : ", req.body.name);
            
                if (err) throw err
                if (!user) {
                    res.json({success: false, msg: 'Authentication Failed, User not found', connected:false})
                }

                else {
                    user.comparePassword(req.body.password, function (err, isMatch) {
                        if (isMatch && !err) {
                            var token = jwt.encode(user, config.secret)
                            var iduser = user._id.valueOf();
                            console.log("iduser  : ", iduser);

                            var nameById = getNameById(iduser);
                            console.log("name  : ", nameById);


                            res.json({success: true, token: token, iduser:iduser, connected:true, name:nameById});
                        }
                        else {
                            return res.json({success: false, msg: 'Authentication failed, wrong password', connected:false});
                        }
                    })
                }
        }
        )
    },

    // ajoutez un commentaires, en fonction de l'id de l'user connecté sur le page de login
    addComment: function (req,res) {
        var myobj = {  
            "_id": req.body.id  ,"comments.body": req.body.body, "comments.commentBy": req.body.commentBy 
            };
        
            
        
        Vin.updateOne(
            { "_id": req.body.id },
            
                {$push:{"comments":{
                    "body":req.body.body,
                    "commentBy": req.body.commentBy,
                  }}
            }
            
        , function(err, com) {
            if (err) throw err;
            if (!com) {
                res.json({success: false, msg: 'add comm Failed, '});
            }

            else {
                res.json({success: true, msg: 'add comm success'});
            }
            
        });

        /**
        Vin.insert(myobj, function(err, com) {
            if (err) throw err;
            if (!com) {
                res.json({success: false, msg: 'add comm Failed, '});
            }

            else {
                res.json({success: true, msg: 'add comm success'});
            }
            
        });
         */
    },

    // add like, pas encore fait 
    addLike: function (req,res) {
        Vin.updateOne({
            _id: req.body.id,
            
        }, {
            $inc: {
                likes: 1
            }
        }, function(err,addyes){
            if (err) throw err
                if (!addyes) {
                    res.json({success: false, msg: 'add like Failed, '});
                }

                else {
                    res.json({success: true, msg: 'add like success'});
                }
        }
        )
        
    },



    getinfo: function (req, res) {
        if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
            var token = req.headers.authorization.split(' ')[1]
            var decodedtoken = jwt.decode(token, config.secret)
            return res.json({success: true, msg: 'Hello ' + decodedtoken.name})
        }
        else {
            return res.json({success: false, msg: 'No Headers'})
        }
    },

    getOneUser: function(req,res) {
    User.find({ name: 'admin' }).then(user),function (error,data)  {
        if(error){
            return console.log(error);
        }else {
            return console.log(data);
        }
    };

        
    }
}

function getNameById(iduser) {
    User.findById(iduser, function (err, getname) {
        if(err) throw err;
        if(getname) {
            console.log("la on trouve bien le nom", getname.name);
            
            return getname.name;
            
        } else {
            console.log("la on pas trouvé le nom");
        }
    });

}







function existId(array, id) {
    for (const property in array) 
       if( property == id){
            return array[property];
       }
} 

module.exports = functions