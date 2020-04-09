<template>
  <div id="app">
    <b-navbar type="dark" variant="dark">
      <b-navbar-brand to="/">TBO</b-navbar-brand>
      <b-navbar-nav>

        <!-- Navbar dropdowns -->
        <b-nav-item-dropdown text="Bénévoles" v-if="getLogin">
          <b-dropdown-item to="/benevoles" v-if="getRole === 'admin' || getRole === 'DLUS' || getRole === 'DLAS'">Liste</b-dropdown-item>
          <b-dropdown-item to="/benevoles/competences-crf" v-if="getRole === 'admin' || getRole === 'DLUS' || getRole === 'DLAS'">Compétences CRf</b-dropdown-item>
          <b-dropdown-item to="/benevoles/competences-non-crf"  v-if="getRole === 'admin' || getRole === 'DLUS' || getRole === 'DLAS'">Compétences Hors CRf</b-dropdown-item>
          <b-dropdown-item to="/benevoles/recyclage" v-if="getRole === 'admin' || getRole === 'DLUS'">Recyclage</b-dropdown-item>
          <b-dropdown-item to="/benevoles/extract" v-if="getRole === 'admin' || getRole === 'DLUS' || getRole === 'DLAS'">Extraction</b-dropdown-item>
        </b-nav-item-dropdown>

        <b-nav-item-dropdown text="Organisation" v-if="getLogin">
          <b-dropdown-item to="#">Organigramme</b-dropdown-item>
          <b-dropdown-item to="#">Gestion parrain/marraine</b-dropdown-item>
          <b-dropdown-item to="#">Souhaits</b-dropdown-item>
          <b-dropdown-item to="#">Cotisation</b-dropdown-item>
          <b-dropdown-item to="#">Gestion budget</b-dropdown-item>
          <b-dropdown-item to="#">Fiche de fonctions</b-dropdown-item>
        </b-nav-item-dropdown>

        <b-nav-item-dropdown text="Evenements" v-if="getLogin">
          <b-dropdown-item to="#">Muguet</b-dropdown-item>
          <b-dropdown-item to="#">Quête</b-dropdown-item>
        </b-nav-item-dropdown>

        <b-nav-item-dropdown text="US" v-if="getLogin">
          <b-dropdown-item to="#">Retour FPS</b-dropdown-item>
          <b-dropdown-item to="#">Retour CI</b-dropdown-item>
        </b-nav-item-dropdown>

        <b-nav-item-dropdown text="Statistique" v-if="getLogin">
          <b-dropdown-item to="#">Points</b-dropdown-item>
          <b-dropdown-item to="#">Statistique US</b-dropdown-item>
          <b-dropdown-item to="#">Statistique AS</b-dropdown-item>
        </b-nav-item-dropdown>

        <b-nav-item-dropdown text="Logistique" v-if="getLogin">
          <b-dropdown-item to="/logistique/uniformes">Uniformes</b-dropdown-item>
          <b-dropdown-item to="#">Gestion du matériel - OP</b-dropdown-item>
          <b-dropdown-item to="#">Gestion du matériel - FORM</b-dropdown-item>
          <b-dropdown-item to="#">Retour de mission</b-dropdown-item>
        </b-nav-item-dropdown>

        <b-nav-item to="/about">About</b-nav-item>
      </b-navbar-nav>

      <b-navbar-nav class="ml-auto" v-if="getLogin">
        <b-button variant="outline-success" class="my-2 my-sm-0" v-on:click="login">Logout</b-button>
      </b-navbar-nav>

      <b-navbar-nav class="ml-auto" v-else>
        <b-form-input class="mr-sm-2" placeholder="username" v-model="username"></b-form-input>
        <b-form-input class="mr-sm-2" placeholder="password" v-model="password" type="password"></b-form-input>
        <b-button variant="outline-success" class="my-2 my-sm-0" v-on:click="login">Login</b-button>
      </b-navbar-nav>

    </b-navbar>

    <router-view/>

    <div class="container">
      <div class="row justify-content-md-center">
        <div class="col col-lg-2"></div>
        <div class="col-md-auto">
          This is a footer
        </div>
        <div class="col col-lg-2"></div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  data: function () {
    return {
      username: '',
      password: ''
    }
  },
  computed: {
    ...mapGetters('identity', {
      getLogin: 'getLogin',
      getRole: 'getRole'
    })
  },
  methods: {
    login: function () {
      if (this.getLogin === true) {
        console.log('deconnexion')
        this.$store.commit('identity/logout')
      } else {
        console.log('connexion')
        this.$store.commit('identity/login', {
          name: this.username,
          password: this.password
        })
      }
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
</style>
