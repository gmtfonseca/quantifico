<template>
  <v-combobox
    v-model="computedValue"
    class="combo"
    :items="items"
    type="number"
    append-icon=""
    :counter="counter"
    :error-messages="validation"
    hide-no-data
    :search="search"
    hide-selected
    :hint="hint"
    :label="label"
    multiple
    small-chips
  >
  </v-combobox>
</template>

<script>
export default {
  model: {
    prop: 'value',
    event: 'change'
  },
  props: {
    value: {
      type: Array,
      default: function() {
        return []
      }
    },
    label: {
      type: String,
      required: true
    },
    items: {
      type: Array,
      default: function() {
        return []
      }
    },
    hint: {
      type: String,
      default: ''
    },
    counter: {
      type: Number,
      default: undefined
    },
    validation: {
      type: Array,
      default() {
        return []
      }
    }
  },
  data() {
    return {
      search: ''
    }
  },
  computed: {
    computedValue: {
      get() {
        return this.value
      },
      set(value) {
        this.$emit('change', value)
      }
    }
  }
}
</script>

<style>
.combo input[type='number'] {
  -moz-appearance: textfield;
}
.combo input::-webkit-outer-spin-button,
.combo input::-webkit-inner-spin-button {
  -webkit-appearance: none;
}
</style>
