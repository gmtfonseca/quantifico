import FormatService from '@/services/FormatService'

export default {
  install(Vue) {
    Vue.filter('formatDate', function(value) {
      if (!value) return ''

      return FormatService.formatDate(value)
    })

    Vue.filter('formatCurrency', function(value) {
      if (!value) return ''

      return Number(value).toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'BRL'
      })
    })
  }
}
