const http = require('http');
const express = require('express')
const morgan = require('morgan')
const cors = require('cors')
//const connectDB = require('./config/db')
const passport = require('passport')
const bodyParser = require('body-parser')
//const routes = require('./routes/index')
const path = require('path');
//var User = require('./models/user')
//var Vin = require('./models/vin')
//const user = require('./models/user')
//const router = require('./routes/index')
const multer = require('multer');
const {spawn} = require('child_process');


const app = express()
// set up multer middleware to handle multipart/form-data


const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'touslesaudios/');
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage });


app.use(express.json());
app.use(express.static("express"));


if (process.env.NODE_ENV === 'development') {
    app.use(morgan('dev'))
}


app.use(cors())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
//app.use(routes)
app.use(passport.initialize())
//require('./config/passport')(passport)


// handle audio file upload
app.post('/audiosend', upload.single('audio'), (req, res) => {
    try {
      const { path: filePath, mimetype } = req.file;
      // do something with the audio file (e.g. save it to disk, process it, etc.)
      //console.log("path : " + path.filePath);

      
      console.log(req.file);

    
      
      console.log("bien recu");
      res.json({success: "success de fou la"});

      
      //res.status(200).send('Audio file uploaded successfully');
    } catch (e) {
      console.log(e);
      res.status(500).send('Error uploading audio file');
    }
});

app.get('/', (req, res) => {
 
  var dataToSend;
  var TALstring;
  // spawn new child process to call the python script
  const python = spawn('python3', ['test.py']);
  

  // collect data from script
  python.stdout.on('data', function (data) {
   console.log('Pipe data from python script test py ');
   dataToSend = data.toString();
  });

  // in close event we are sure that stream from child process is closed
  python.on('close', (code) => {
  console.log(`child process close all stdio with code ${code}`);
  // send data to browser
  
  });


  const pythonTAL = spawn('python3', ['TAL.py','lance lamusique']);


  pythonTAL.stdout.on('data', function(data) {
    console.log('script tal')
    TALstring = data.toString();
  })


  pythonTAL.on('close', (code) => {
    console.log(`resultat requete tal with code${code}`);
    // send data to browser
    res.send(TALstring);
    
    });

  
})


const PORT = process.env.PORT || 3000

app.listen(PORT, function(){
    console.log("let's go en fait");
})