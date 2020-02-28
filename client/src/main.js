import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import Vuelidate from 'vuelidate'
import vuetify from './plugins/vuetify'
import VueSocketIO from 'vue-socket.io'
import QFilters from './plugins/QFilters'
import network from './config/network'
import '@mdi/font/css/materialdesignicons.css'

Vue.use(Vuelidate)
Vue.use(QFilters)
Vue.use(
  new VueSocketIO({
    debug: true,
    connection: `${network.api.url}/?token=${store.getters.token}`
  })
)

Vue.config.productionTip = false

new Vue({
  router,
  store,
  vuetify,
  render: h => h(App)
}).$mount('#app')
