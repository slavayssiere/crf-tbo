import Vue from 'vue'
import Vuex from 'vuex'

import identity from './modules/identity'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    identity
  },
  mutations: {
  },
  getters: {
  },
  actions: {
  }
})
