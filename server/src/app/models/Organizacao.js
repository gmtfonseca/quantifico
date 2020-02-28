const mongoose = require('mongoose')

const Organizacao = new mongoose.Schema({
  cnpj: {
    type: String,
    required: true,
    unique: true
  },
  razaoSocial: {
    type: String,
    required: true
  },
  fantasia: {
    type: String
  },
  endereco: {
    rua: String,
    numero: String,
    cep: String,
    uf: String,
    municipio: {
      descricao: String
    },
    pais: {
      descricao: String
    }
  },
  computador: {
    nome: String,
    diretorio: String
  },
  dataCriacao: {
    type: Date,
    default: Date.now
  }
})

module.exports = mongoose.model('Organizacao', Organizacao)
