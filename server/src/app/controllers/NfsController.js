const { NfsByOrganizacao: Nfs } = require('../models/nfs/Nfs')
const saidasPlotsFunctions = require('../modules/plots/saidas')

class NfsController {
  async index (req, res) {
    let filters = {}

    if (req.query.data_ini || req.query.data_fim) {
      filters.dataEmissao = {}

      if (req.query.data_ini) {
        filters.dataEmissao.$gte = req.query.data_ini
      }

      if (req.query.data_fim) {
        filters.dataEmissao.$lte = req.query.data_fim
      }
    }

    if (req.query.cliente) {
      filters = {
        ...filters,
        'cliente.razaoSocial': new RegExp(req.query.cliente, 'i')
      }
    }

    const nfs = await Nfs(req.organizacaoId).paginate(filters, {
      page: req.query.page || 1,
      limit: 20,
      sort: '-dataEmissao',
      populate: ['saidas']
    })

    return res.json(nfs)
  }

  async show (req, res) {
    const nf = await Nfs(req.organizacaoId)
      .findById(req.params.id)
      .populate('saidas')

    return res.json(nf)
  }

  async store (req, res) {
    const nfCriada = await Nfs(req.organizacaoId).insereFromJson(req.body)

    req.io.sockets.in(req.organizacaoId).emit('refresh', true)

    return res.json(nfCriada)
  }

  async destroy (req, res) {
    const nf = await Nfs(req.organizacaoId).deletaById(req.params.id)

    req.io.sockets.in(req.organizacaoId).emit('refresh', true)

    return res.json(nf)
  }

  async plot (req, res, next) {
    const saidasPlotFunction = saidasPlotsFunctions[req.params.name]

    if (!saidasPlotFunction) {
      // TODO - Arrumar xd
      return next(new Error('Gráfico não encontrado'))
    }

    const dados = await saidasPlotFunction(req.organizacaoId, req.query)
    return res.json(dados)
  }
}

module.exports = new NfsController()
