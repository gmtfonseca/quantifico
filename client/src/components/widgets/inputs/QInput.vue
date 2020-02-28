<template>
  <v-text-field
    v-model="localValue"
    v-bind="$attrs"
    :error-messages="validation"
    :label="label"
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

<style scoped></style>
