<template>
  <v-menu
    v-model="computedShow"
    :close-on-content-click="false"
    transition="slide-y-transition"
    z-index="4"
    :nudge-width="330"
    :max-width="330"
    left
  >
    <template v-slot:activator="{ on }">
      <slot name="activator" :on="on"> </slot>
    </template>

    <v-card>
      <slot name="body"> </slot>

      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn small text color="primary" @click="onOk">
          Ok
        </v-btn>
        <v-btn small text @click="onReset">
          Resetar
        </v-btn>
        <v-btn small text @click="onClose">
          Cancelar
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-menu>
</template>

<script>
export default {
  components: {},
  model: {
    prop: 'show',
    event: 'change'
  },
  props: {
    show: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    computedShow: {
      get() {
        return this.show
      },
      set(show) {
        this.$emit('change', show)
      }
    }
  },
  watch: {
    show: function() {
      if (this.show) {
        this.$emit('open')
      }
    }
  },
  methods: {
    onOk() {
      this.$emit('apply')
    },
    onReset() {
      this.$emit('reset')
    },
    onClose() {
      this.computedShow = false
    }
  }
}
</script>

<style lang="scss" scoped></style>
