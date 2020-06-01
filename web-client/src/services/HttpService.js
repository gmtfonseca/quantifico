import network from '../config/network'
import axios from 'axios'
import store from '../store'

export default class {
  constructor(endpoint) {
    this.uri = `${network.api.url}/${endpoint}`
  }

  async get(params) {
    return await axios.get(this.uri, {
      params: params,
      headers: { Authorization: store.getters.token }
    })
  }

  async getId(id) {
    return await axios.get(`${this.uri}/${id}`, {
      headers: { Authorization: store.getters.token }
    })
  }

  async post(body) {
    return await axios.post(this.uri, body, {
      headers: { Authorization: store.getters.token }
    })
  }

  async put(id, body) {
    return await axios.put(`${this.uri}/${id}`, body, {
      headers: { Authorization: store.getters.token }
    })
  }

  async delete(id) {
    return await axios.delete(`${this.uri}/${id}`, {
      headers: { Authorization: store.getters.token }
    })
  }
}
