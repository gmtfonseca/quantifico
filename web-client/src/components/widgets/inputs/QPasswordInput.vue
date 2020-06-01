<template>
  <v-text-field
    v-model="localValue"
    :append-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
    :type="show ? 'text' : 'password'"
    :error-messages="validation"
    v-bind="$attrs"
    :label="label"
    autocomplete="new-password"
    @click:append="show = !show"
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
  data() {
    return {
      show: false
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
