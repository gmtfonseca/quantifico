const { NfsByOrganizacao: Nfs } = require('../models/nfs/Nfs')
const SyncNfsStream = require('../modules/nfs/SyncNfsStream')

class SyncNfsController {
  async store (req, res) {
    const nfsModel = Nfs(req.organizacaoId)
    const syncNfsStream = new SyncNfsStream(nfsModel)
    req
      .on('data', async dados => {
        syncNfsStream.recebeDadosNfsSaida(dados)
      })
      .on('end', async () => {
        await syncNfsStream.insereNfsSaida()

        req.io.sockets.in(req.organizacaoId).emit('refresh', true)

        const snapshot = await nfsModel.getSnapshot()
        return res.json({
          estadoServidor: snapshot,
          arquivosInvalidos: syncNfsStream.arquivosInvalidos
        })
      })
  }

  async destroy (req, res) {
    const arquivosDeletados = Array.from(req.body)
    const nfsModel = Nfs(req.organizacaoId)
    await nfsModel.deletaByArquivos(arquivosDeletados)
    req.io.sockets.in(req.organizacaoId).emit('refresh', true)
    const snapshot = await nfsModel.getSnapshot()
    return res.json(snapshot)
  }
}

module.exports = new SyncNfsController()
