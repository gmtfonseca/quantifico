<template>
  <VueApexCharts type="line" :options="computedOptions" :series="series" />
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
          // Insert here standard options
          chart: {
            toolbar: {
              show: false
            }
          }
        },
        this.options
      )
    }
  }
}
</script>

<style lang="scss" scoped></style>
