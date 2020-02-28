<template>
  <v-select v-model="computedValue" :items="items" :label="label"></v-select>
</template>

<script>
export default {
  model: {
    prop: 'value',
    event: 'change'
  },
  props: {
    value: {
      type: Number,
      default: 1
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
