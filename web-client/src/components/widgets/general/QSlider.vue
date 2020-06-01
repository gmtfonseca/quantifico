<template>
  <v-slider
    v-model="computedValue"
    color="primary"
    :label="label"
    :hint="hint"
    :min="min"
    :max="max"
    thumb-label
  ></v-slider>
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
    hint: {
      type: String,
      default: ''
    },
    min: {
      type: Number,
      required: true
    },
    max: {
      type: Number,
      required: true
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
