<template>
  <v-menu
    v-model="computedShow"
    :close-on-content-click="false"
    transition="slide-y-transition"
    z-index="4"
    left
  >
    <template v-slot:activator="{ on }">
      <slot name="activator" :on="on"> </slot>
    </template>

    <v-list class="options" dense subheader>
      <v-subheader>CUSTOMIZAÇÕES</v-subheader>
      <v-list-item-group v-model="item" color="primary">
        <v-list-item>
          <v-list-item-content>
            <v-list-item-title class="options__title"
              >Editar container</v-list-item-title
            >
          </v-list-item-content>
          <v-list-item-icon>
            <v-icon small>mdi-card-outline</v-icon>
          </v-list-item-icon>
        </v-list-item>
        <v-list-item>
          <v-list-item-content>
            <v-list-item-title class="options__title"
              >Editar gráfico</v-list-item-title
            >
          </v-list-item-content>
          <v-list-item-icon>
            <v-icon small>mdi-poll</v-icon>
          </v-list-item-icon>
        </v-list-item>
        <v-subheader>OUTROS</v-subheader>
        <v-list-item>
          <v-list-item-content>
            <v-list-item-title class="options__title"
              >Exportar</v-list-item-title
            >
          </v-list-item-content>
          <v-list-item-icon>
            <v-icon small>mdi-download</v-icon>
          </v-list-item-icon>
        </v-list-item>
      </v-list-item-group>
    </v-list>
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
  data() {
    return {
      item: null
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
  methods: {}
}
</script>

<style lang="scss" scoped>
.options {
  .options__title {
    font-size: 0.9rem;
  }
}
</style>
