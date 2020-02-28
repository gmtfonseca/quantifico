<template>
  <v-btn v-bind="$attrs" color="primary" :type="type" v-on="listeners">
    {{ text }}
  </v-btn>
</template>

<script>
export default {
  props: {
    text: {
      type: String,
      required: true
    },
    type: {
      type: String,
      default: null
    }
  },
  computed: {
    listeners() {
      return Object.assign({}, this.$listeners)
    }
  }
}
</script>

<style scoped></style>
