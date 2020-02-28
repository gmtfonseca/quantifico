import HttpService from '../../services/HttpService'
import jwtDecode from 'jwt-decode'

const KEY_NAME = 'access_token'
const TOKEN_TYPE = 'Bearer'

const state = {
  token: localStorage.getItem(KEY_NAME)
}

const mutations = {
  setToken: function(state, token) {
    localStorage.setItem(KEY_NAME, token)
    state.token = token
  },
  removeToken: function(state) {
    localStorage.removeItem(KEY_NAME)
    state.token = ''
  }
}

const getters = {
  isLoggedIn: state => {
    if (state.token) {
      const currTime = new Date().getTime() / 1000
      const decodedToken = jwtDecode(state.token)
      return decodedToken.exp > currTime
    } else {
      return false
    }
  },
  organizacao: state => {
    if (!state.token) return ''

    return jwtDecode(state.token).organizacao
  },
  token: state => `${TOKEN_TYPE} ${state.token}`
}

const actions = {
  login: async (context, user) => {
    const userService = new HttpService('sessao')
    const body = { email: user.email, senha: user.password }

    try {
      const res = await userService.post(body)
      context.commit('setToken', res.data.token)
      return res
    } catch (e) {
      context.commit('removeToken')
      throw e
    }
  },
  logout: context => {
    context.commit('removeToken')
  }
}

export default {
  state,
  mutations,
  getters,
  actions
}
