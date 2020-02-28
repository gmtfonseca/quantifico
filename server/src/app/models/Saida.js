const mongoose = require('mongoose')
const Schema = mongoose.Schema
const mongoTenant = require('mongo-tenant')

const multiTenantConfig = require('../../config/multiTenant')
const modelSelector = require('../modules/database/ModelSelector')

const Saida = mongoose.Schema({
  organizacao: {
    type: Schema.Types.ObjectId,
    ref: 'Organizacao',
    required: true
  },
  nfs: {
    type: Schema.Types.ObjectId,
    ref: 'Nfs',
    required: true,
    index: true
  },
  produto: {
    codigo: {
      type: String,
      required: true
    },
    descricao: {
      type: String,
      required: true
    },
    ean: String,
    ncm: Number,
    unidadeComercial: String
  },
  cfop: Number,
  quantidade: {
    type: Number,
    required: true
  },
  valor: {
    unitario: {
      type: Number,
      required: true
    },
    total: {
      type: Number,
      required: true
    },
    frete: Number,
    desconto: Number,
    outro: Number
  }
  // TODO - Contemplar tributações
})

Saida.statics = {
  async insereMultiplas (saidas, nfId) {
    let saidasCriadas = []
    for (const saida of saidas) {
      const saidaCriada = await this.create({
        ...saida,
        nfs: nfId
      })
      saidasCriadas.push(saidaCriada)
    }

    return saidasCriadas
  }
}

Saida.plugin(mongoTenant, multiTenantConfig)

const SaidaModel = mongoose.model('Saida', Saida)
const SaidaByOrganizacao = organizacao =>
  modelSelector(organizacao, SaidaModel)

module.exports = { SaidaModel, SaidaByOrganizacao }
