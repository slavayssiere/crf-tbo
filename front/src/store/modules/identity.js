const state = {
  login: false,
  name: 'anonymus',
  role: 'anonymus'
}

const getters = {
  getLogin: state => {
    return state.login
  },
  getRole: state => {
    return state.role
  }
}

const mutations = {
  login (state, user) {
    state.login = true
    state.name = user.name
    state.role = user.name
    localStorage.login = state.login
    localStorage.role = state.role
  },
  logout (state) {
    state.login = false
    state.role = 'anonymus'
    localStorage.login = state.login
    localStorage.role = state.role
    window.location.href = '/'
  }
}

const actions = {}

export default {
  namespaced: false,
  state,
  getters,
  actions,
  mutations
}
