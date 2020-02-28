<template>
  <v-dialog v-model="computedShow" width="400" @input="onOpenClose">
    <template v-slot:activator="{ on }">
      <slot name="activator" :on="on"></slot>
    </template>

    <v-card>
      <v-card-title>
        Filtros globais
      </v-card-title>

      <div class="filters">
        <div class="filters__date-pickers">
          <QDatePicker v-model="filters.startDate" label="Data inicial" />
          <div class="spacer"></div>
          <QDatePicker v-model="filters.endDate" label="Data final" />
        </div>
      </div>

      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="primary" text @click="onOk">
          Ok
        </v-btn>
        <v-btn text @click="onReset">
          Resetar
        </v-btn>
        <v-btn text @click="onCancel">
          Cancelar
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import QDatePicker from '@/components/widgets/pickers/QDatePicker'

function initialState() {
  return {
    filters: {
      startDate: null,
      endDate: null
    }
  }
}
export default {
  components: { QDatePicker },
  model: {
    prop: 'show',
    event: 'change'
  },
  props: {
    show: {
      type: Boolean,
      default: false
    },
    globalFilters: {
      type: Object,
      default: function() {
        return {}
      }
    }
  },
  data() {
    return initialState()
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
  methods: {
    onOk() {
      this.computedShow = false
      this.$emit('apply', this.filters)
    },
    onReset() {
      this.filters = initialState().filters
    },
    onCancel() {
      this.computedShow = false
    },
    onOpenClose(show) {
      if (show) {
        this.init()
      }
    },
    init() {
      this.filters = { ...this.globalFilters }
    }
  }
}
</script>

<style lang="scss" scoped>
.filters {
  box-sizing: border-box;
  padding: 0 1.5rem;
  padding-bottom: 0;

  .filters__date-pickers {
    display: flex;
    justify-content: space-evenly;

    .spacer {
      margin: 0.5rem;
    }
  }
}
</style>
