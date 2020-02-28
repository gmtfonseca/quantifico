require('dotenv').config()
const mongoose = require('mongoose')
const databaseConfig = require('../../src/config/database')

const abreConexao = async () => {
  await mongoose.connect(databaseConfig.uri, {
    useCreateIndex: true,
    useNewUrlParser: true
  })
}

const fechaConexao = async () => {
  await mongoose.connection.db.dropDatabase()
  await mongoose.disconnect()
}

module.exports = { abreConexao, fechaConexao }
