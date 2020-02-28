const mongoose = require('mongoose')
const Schema = mongoose.Schema
const nfsStatics = require('./nfsStatics')
const nfsMethods = require('./nfsMethods')
const nfsHooks = require('./nfsHooks')
const mongoTenant = require('mongo-tenant')
const multiTenantConfig = require('../../../config/multiTenant')
const modelSelector = require('../../modules/database/ModelSelector')
const mongoosePaginate = require('mongoose-paginate')

const Nfs = Schema({
  organizacao: {
    type: Schema.Types.ObjectId,
    ref: 'Organizacao',
    required: true
  },
  idSefaz: {
    type: String,
    required: true,
    index: true,
    unique: true
  },
  serie: {
    type: String,
    required: true
  },
  numero: {
    type: Number,
    required: true,
    index: true
  },
  naturezaOperacao: String,
  dataEmissao: Date,
  dataEmissaoDecomposta: {
    dia: Number,
    mes: Number,
    ano: Number
  },
  /*
    1=Operação interna
    2=Operação interestadual
    3=Operação com exterior
  */
  localDestino: {
    type: Number,
    min: 1,
    max: 3,
    validate: {
      validator: Number.isInteger
    }
  },
  /*
    1=Produção
    2=Homologação
  */
  tipoAmbiente: {
    type: Number,
    min: 1,
    max: 2,
    validate: {
      validator: Number.isInteger
    }
  },
  /*
    1=NF-e normal
    2=NF-e complementar
    3=NF-e de ajuste
    4=Devolução/Retorno
  */
  finalidadeEmissao: {
    type: Number,
    min: 1,
    max: 4,
    validate: {
      validator: Number.isInteger
    }
  },
  cliente: {
    cnpj: {
      type: String,
      required: true
    },
    razaoSocial: {
      type: String,
      required: true
    },
    nomeFantasia: String,
    endereco: {
      logradouro: String,
      numero: String,
      cep: String,
      uf: String,
      municipio: {
        codigo: Number,
        descricao: String
      },
      pais: {
        codigo: Number,
        descricao: String
      }
    }
  },
  saidas: [
    {
      type: Schema.Types.ObjectId,
      ref: 'Saida'
    }
  ],
  total: {
    produtos: Number,
    desconto: Number,
    frete: Number,
    nf: Number
  },
  arquivo: {
    nome: String,
    dataModificacao: Date,
    estado: String
  },
  dadosAdicionais: {
    versao: String,
    naoUtilizados: String
  }
})

Nfs.statics = nfsStatics
Nfs.methods = nfsMethods
nfsHooks(Nfs)

Nfs.plugin(mongoTenant, multiTenantConfig)
Nfs.plugin(mongoosePaginate)

const NfsModel = mongoose.model('Nfs', Nfs)

const NfsByOrganizacao = organizacao =>
  modelSelector(organizacao, mongoose.model('Nfs', Nfs))

module.exports = { NfsModel, NfsByOrganizacao }
