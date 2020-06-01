<template>
  <div class="wrapper">
    <TopBar />
    <SideBar />
    <v-content class="content">
      <v-container fluid>
        <router-view />
      </v-container>
    </v-content>
  </div>
</template>

<script>
import TopBar from '@/views/shared/TopBar'
import SideBar from '@/views/shared/SideBar'

export default {
  name: 'Home',
  components: { TopBar, SideBar },
  data() {
    return {}
  },
  mounted() {
    this.connectSocket()
  },
  methods: {
    connectSocket() {
      this.$socket.emit('connectQuantifico', this.$store.getters.organizacao)
    }
  }
}
</script>

<style scoped>
.wrapper,
.content {
  height: 100%;
  width: 100%;
}
</style>
