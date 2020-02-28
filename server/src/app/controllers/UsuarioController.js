const { UsuarioByOrganizacao: Usuario } = require('../models/Usuario')

class UsuarioController {
  async index (req, res) {
    const usuarios = await Usuario(req.organizacaoId).find()

    return res.json(usuarios)
  }

  async show (req, res) {
    const usuario = await Usuario(req.organizacaoId).findById(req.params.id)

    return res.json(usuario)
  }

  async store (req, res) {
    const usuario = await Usuario('*').create(req.body)

    return res.json(usuario)
  }

  async destroy (req, res) {
    const usuario = await Usuario(req.organizacaoId).deleteOne({
      _id: req.params.id
    })

    return res.json(usuario)
  }
}

module.exports = new UsuarioController()
