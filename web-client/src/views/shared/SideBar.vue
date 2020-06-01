<template>
  <v-navigation-drawer
    v-model="drawer"
    mobile-break-point="1264"
    clipped
    disable-resize-watcher
    app
  >
    <v-list dense nav>
      <v-list-item link :to="{ name: 'dashboard' }">
        <v-list-item-icon>
          <v-icon>mdi-view-dashboard</v-icon>
        </v-list-item-icon>

        <v-list-item-title>Dashboard</v-list-item-title>
      </v-list-item>

      <v-list-group id="plots" prepend-icon="mdi-poll-box" no-action>
        <template v-slot:activator>
          <v-list-item-content>
            <v-list-item-title>Indicadores</v-list-item-title>
          </v-list-item-content>
        </template>

        <v-list-item link :to="{ name: 'saidas' }">
          <v-list-item-icon>
            <v-icon>mdi-account-supervisor-circle</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>Saídas</v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <v-list-item link :to="{ name: 'entradas' }">
          <v-list-item-icon>
            <v-icon>mdi-toolbox</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>Entradas</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-group>

      <v-list-item link :to="{ name: 'nf' }">
        <v-list-item-icon>
          <v-icon>mdi-file-document-box-multiple</v-icon>
        </v-list-item-icon>
        <v-list-item-title>Notas Fiscais</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
function initialState() {
  return {}
}

export default {
  name: 'SideBar',
  components: {},
  data() {
    return initialState()
  },
  computed: {
    drawer: {
      get() {
        return this.$store.getters.expanded
      },
      set(value) {
        this.$store.commit('setStateSideBar', value)
      }
    }
  },
  methods: {
    onLogout() {
      this.$store.dispatch('logout')
      this.$router.push({ name: 'login' })
    }
  }
}
</script>

<style lang="scss">
.v-list-item.v-list-item--active {
  // color: #3700b5 !important;
  color: #7159c1 !important;
}

.v-list-group__header.v-list-item.v-list-item--active {
  color: #000 !important;
  opacity: 0.87 !important;
}

.v-list-group__header.v-list-item.v-list-item--active .v-icon {
  color: #000 !important;
  opacity: 0.54 !important;
}
</style>
