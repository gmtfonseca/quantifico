import moment from 'moment'

export default {
  format(date) {
    return moment(date).format('DD/MM/YYYY')
  }
}
