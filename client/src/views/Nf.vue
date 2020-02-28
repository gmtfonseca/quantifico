<template>
  <Wrapper>
    <v-card class="filters">
      <h2>TODO - Filters / Pagination</h2>
    </v-card>

    <v-data-table
      :headers="headers"
      :items="nfsSaida"
      item-key="_id"
      show-expand
      :server-items-length="nfsTotal"
      hide
      the
      default
      class="nfs-table"
      no-data-text="Nenhuma Nota Fiscal encontrada"
      :loading="waitingResponse"
      loading-text="Carregando suas Notas Fiscais..."
    >
      <template v-slot:item.dataEmissao="{ item }">
        <span>{{ item.dataEmissao | formatDate }}</span>
      </template>

      <template v-slot:item.total.nf="{ item }">
        <span>{{ item.total.nf | formatCurrency }}</span>
      </template>

      <template v-slot:expanded-item="{ item }">
        <td class="nfs-table__saidas-wrapper" :colspan="headers.length">
          <v-data-table
            dense
            dark
            :headers="headersSaida"
            :items="item.saidas"
            item-key="_id"
            hide-default-footer
            class="nfs-table__saidas-table"
            no-data-text="Nenhum item encontrado"
          >
            <template v-slot:item.valor.unitario="{ item }">
              <span>{{ item.valor.unitario | formatCurrency }}</span>
            </template>
            <template v-slot:item.valor.total="{ item }">
              <span>{{ item.valor.total | formatCurrency }}</span>
            </template>
          </v-data-table>
        </td>
      </template>
    </v-data-table>
  </Wrapper>
</template>

<script>
import HttpService from '@/services/HttpService'

function initialState() {
  return {
    nfsService: new HttpService('nfs'),
    nfsSaida: [],
    nfsTotal: 0,
    waitingResponse: false,
    filters: {
      numero: null,
      cliente: null,
      dataEmissao: null
    },
    headers: [
      { text: 'Série', value: 'serie' },
      { text: 'Número', value: 'numero' },
      { text: 'Data Emissão', value: 'dataEmissao' },
      { text: 'Cliente', value: 'cliente.razaoSocial' },
      { text: 'Valor Total', value: 'total.nf', align: 'right' },
      { text: '', value: 'data-table-expand' }
    ],
    headersSaida: [
      { text: 'Produto', value: 'produto.descricao' },
      { text: 'Quantidade', value: 'quantidade', align: 'right' },
      { text: 'Valor Unitário', value: 'valor.unitario', align: 'right' },
      { text: 'Valor Total', value: 'valor.total', align: 'right' }
    ]
  }
}

export default {
  name: 'Nf',
  data() {
    return initialState()
  },
  mounted() {
    this.queryNfsSaida()
  },
  methods: {
    async queryNfsSaida() {
      try {
        this.waitingResponse = true
        const res = await this.nfsService.get()
        this.nfsSaida = res.data.docs
        this.nfsTotal = res.data.total
        console.log(res.data.docs)
      } catch (e) {
        console.log(e)
      } finally {
        this.waitingResponse = false
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import '@/config/device.scss';

.wrapper {
  height: 100%;

  @media (min-width: $tablet) {
    padding: 1rem;
  }
}

.filters {
  padding: 1rem;
  display: flex;
  align-items: center;
  margin-bottom: 1rem;

  .filters__field {
    margin: 0 0.8rem;
  }
}

.nfs-table {
  border: 1px solid #ddd;

  .nfs-table__saidas-wrapper {
    padding: 0.8rem;

    .nfs-table__saidas-table {
      width: 100%;
      height: 100%;
    }
  }
}
</style>
