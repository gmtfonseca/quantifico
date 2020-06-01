<template>
  <v-app-bar id="app-bar" dense clipped-left flat app color="primary" dark>
    <v-app-bar-nav-icon @click="onToggleSideBar"></v-app-bar-nav-icon>
    <v-spacer></v-spacer>

    <v-menu
      v-model="userMenu"
      :close-on-content-click="false"
      :nudge-width="200"
    >
      <template v-slot:activator="{ on }">
        <v-avatar class="avatar" v-on="on">
          <v-icon>mdi-account-circle</v-icon>
        </v-avatar>
      </template>

      <v-card>
        <v-list>
          <v-list-item>
            <v-list-item-avatar>
              <img src="https://cdn.vuetifyjs.com/images/john.jpg" alt="John" />
            </v-list-item-avatar>

            <v-list-item-content>
              <v-list-item-title>Gustavo Fonseca</v-list-item-title>
              <v-list-item-subtitle>Co-founder</v-list-item-subtitle>
            </v-list-item-content>

            <v-list-item-action>
              <v-btn icon @click="onLogout">
                <v-icon>mdi-door</v-icon>
              </v-btn>
            </v-list-item-action>
          </v-list-item>
        </v-list>

        <v-divider></v-divider>

        <v-list>
          <v-list-item link :to="{ name: 'account' }">
            <v-list-item-icon>
              <v-icon>mdi-account-box</v-icon>
            </v-list-item-icon>
            <v-list-item-title>Conta</v-list-item-title>
          </v-list-item>

          <v-list-item>
            <v-list-item-action>
              <v-switch color="primary"></v-switch>
            </v-list-item-action>
            <v-list-item-title>Opção 1</v-list-item-title>
          </v-list-item>

          <v-list-item>
            <v-list-item-action>
              <v-switch color="primary"></v-switch>
            </v-list-item-action>
            <v-list-item-title>Opção 2</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-card>
    </v-menu>
  </v-app-bar>
</template>

<script>
function initialState() {
  return {
    userMenu: false
  }
}

export default {
  name: 'TopBar',
  components: {},
  data() {
    return initialState()
  },
  computed: {
    pageTitle() {
      return this.$route.meta.label
    }
  },
  methods: {
    onLogout() {
      this.$store.dispatch('logout')
      this.$router.push({ name: 'login' })
    },
    onToggleSideBar() {
      this.$store.commit('toggleSideBar')
    }
  }
}
</script>

<style lang="scss">
#app-bar {
  border-bottom: 1px solid #ddd !important;
}
</style>

<style lang="scss" scoped>
.avatar {
  cursor: pointer;
}
</style>
