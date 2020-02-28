<template>
  <VueApexCharts type="bar" :options="computedOptions" :series="series" />
</template>

<script>
import VueApexCharts from 'vue-apexcharts'

export default {
  components: { VueApexCharts },
  props: {
    series: {
      type: Array,
      required: true
    },
    options: {
      type: Object,
      required: true
    }
  },
  computed: {
    computedOptions() {
      return Object.assign(
        {
          chart: {
            toolbar: {
              show: false
            }
          }
          // Insert here standard options
        },
        this.options
      )
    }
  }
}
</script>

<style lang="scss" scoped></style>
