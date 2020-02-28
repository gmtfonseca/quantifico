<template>
  <VueApexCharts type="pie" :options="chartOptions" :series="series" />
</template>

<script>
import VueApexCharts from 'vue-apexcharts'

export default {
  name: 'PiePlot',
  components: { VueApexCharts }
}
</script>

<style scoped></style>
