import Vue from 'vue'
import Vuex from 'vuex'
import auth from './modules/auth'
import sideBar from './modules/sideBar'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    auth,
    sideBar
  }
})
