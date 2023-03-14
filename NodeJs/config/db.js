const mongoose = require('mongoose')
const dbConfig = require('./dbconfig')
const dsnMongoDB = "mongodb://0.0.0.0:27017/";

const connectDB = async() => {
    try {
        const conn = await mongoose.connect(dsnMongoDB, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        })
        console.log(`MongoDB Connected: ${conn.connection.host}`)
    }
    catch (err) {
        console.log(err)
        process.exit(1)
    }
}

module.exports = connectDB