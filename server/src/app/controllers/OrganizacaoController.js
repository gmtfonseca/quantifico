const Organizacao = require('../models/Organizacao')

class OrganizacaoController {
  async show (req, res) {
    const organizacao = await Organizacao.findById(req.organizacaoId)

    return res.json(organizacao)
  }

  async store (req, res) {
    const organizacao = await Organizacao.create(req.body)

    return res.json(organizacao)
  }

  async update (req, res) {
    const organizacao = await Organizacao.updateOne({ _id: req.organizacaoId }, req.body)

    return res.json(organizacao)
  }
}

module.exports = new OrganizacaoController()
