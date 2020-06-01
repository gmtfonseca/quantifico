import moment from 'moment'
export default {
  formatCurrency(value) {
    return Number(value).toLocaleString('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    })
  },
  formatNumber(value) {
    return Number(value).toLocaleString()
  },
  formatDate(date) {
    return moment(date).format('DD/MM/YYYY')
  }
}
