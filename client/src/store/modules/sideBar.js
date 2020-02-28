// TODO - Calibrar breakpoint e utilizar module device.js
const sideBarMobileBreakpoint = '(min-width: 1264px)'

const state = {
  expanded: window.matchMedia(sideBarMobileBreakpoint).matches
}

const mutations = {
  expandSideBar(state) {
    state.expanded = true
  },
  collapseSideBar(state) {
    state.expanded = false
  },
  toggleSideBar(state) {
    state.expanded = !state.expanded
  },
  setStateSideBar(state, value) {
    state.expanded = value
  }
}

const getters = {
  expanded: state => state.expanded
}

export default {
  state,
  mutations,
  getters
}
