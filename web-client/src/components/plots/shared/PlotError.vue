<template>
  <v-btn class="plot-error__btn-retry" color="primary" small @click="onRefresh">
    Tentar novamente
    <v-icon right> mdi-refresh</v-icon>
  </v-btn>
</template>

<script>
export default {
  components: {},
  props: {},
  methods: {
    onRefresh() {
      this.$emit('refresh')
    }
  }
}
</script>

<style lang="scss" scoped>
.plot-error {
  .plot-error__btn-retry {
    display: block;
  }
}
</style>
