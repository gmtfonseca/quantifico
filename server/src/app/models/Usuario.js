const mongoose = require('mongoose')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')
const Schema = mongoose.Schema
const mongoTenant = require('mongo-tenant')

const authConfig = require('../../config/auth')
const multiTenantConfig = require('../../config/multiTenant')
const modelSelector = require('../modules/database/ModelSelector')

const Usuario = new mongoose.Schema({
  organizacao: {
    type: Schema.Types.ObjectId,
    ref: 'Organizacao',
    required: true
  },
  nome: {
    type: String,
    required: true
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true
  },
  senha: {
    type: String,
    required: true
  },
  dataCriacao: {
    type: Date,
    default: Date.now
  }
})

// Será chamado sempre que houver alguma alteração
Usuario.pre('save', async function (next) {
  if (!this.isModified('senha')) {
    return next()
  }

  this.senha = await bcrypt.hash(this.senha, 8)
})

Usuario.methods = {
  comparePasswordHash (senha) {
    return bcrypt.compare(senha, this.senha)
  }
}

Usuario.statics = {
  generateToken ({ id, organizacao }) {
    return jwt.sign({ id, organizacao }, authConfig.secret, {
      expiresIn: authConfig.ttl
    })
  }
}

Usuario.plugin(mongoTenant, multiTenantConfig)

const UsuarioModel = mongoose.model('Usuario', Usuario)
const UsuarioByOrganizacao = organizacao =>
  modelSelector(organizacao, mongoose.model('Usuario', Usuario))

module.exports = { UsuarioByOrganizacao, UsuarioModel }
