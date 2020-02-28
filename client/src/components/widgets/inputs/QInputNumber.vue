<template>
  <v-text-field
    v-model="localValue"
    class="q-input-number"
    v-bind="$attrs"
    :error-messages="validation"
    :label="label"
    :counter="counter"
    :hint="hint"
    type="number"
    autocomplete="new-password"
    v-on="listeners"
  ></v-text-field>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      default: null
    },
    label: {
      type: String,
      required: true
    },
    validation: {
      type: Array,
      default() {
        return []
      }
    },
    counter: {
      type: Number,
      default: undefined
    },
    hint: {
      type: String,
      default: null
    }
  },
  computed: {
    listeners() {
      return Object.assign({}, this.$listeners)
    },
    localValue: {
      get() {
        return this.value
      },
      set(value) {
        this.$emit('input', value)
      }
    }
  }
}
</script>

<style>
.q-input-number input[type='number'] {
  -moz-appearance: textfield;
}
.q-input-number input::-webkit-outer-spin-button,
.q-input-number input::-webkit-inner-spin-button {
  -webkit-appearance: none;
}
</style>
