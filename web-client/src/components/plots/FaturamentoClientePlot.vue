<template>
  <PlotContainer
    title="FATURAMENTO x CLIENTE"
    :plot="plot"
    @apply-filters="onApplyFilters"
    @reset-filters="onResetFilters"
    @open-filters="onOpenFilters"
  >
    <template v-slot:filters>
      <div class="filters">
        <div class="filters__date-pickers">
          <QDatePicker v-model="filters.startDate" label="Data inicial" />
          <div class="spacer"></div>
          <QDatePicker v-model="filters.endDate" label="Data final" />
        </div>
        <QSelect
          v-model="filters.sort"
          :items="[
            { text: 'Crescente', value: 1 },
            { text: 'Descrescente', value: -1 }
          ]"
          label="Ordenar de maneira"
        />
        <QSlider
          v-model="filters.limit"
          label="Limite"
          hint="Quantas clientes deseja visualizar?"
          :min="1"
          :max="15"
        />
      </div>
    </template>
    <template v-slot:body>
      <BarPlot :series="plot.series" :options="options" />
    </template>
  </PlotContainer>
</template>

<script>
import HttpService from '@/services/HttpService'
import PlotContainer from '@/components/plots/shared/PlotContainer'
import BarPlot from '@/components/plots/models/BarPlot'
import FormatService from '@/services/FormatService'
import Plot from '@/components/plots/shared/Plot'

import { QDatePicker, QSlider, QSelect } from '@/components/widgets/lib'

class FaturamentoClientePlot extends Plot {
  async getSeries() {
    const httpService = new HttpService('nfs/plot/faturamento-cliente')
    const response = await httpService.get(this._params)

    const data = response.data.map(record => {
      return {
        x: record.razaoSocial,
        y: record.totalFaturado
      }
    })

    const series = [{ name: 'Total Faturado', data }]
    return series
  }

  get hasActiveFilters() {
    return Boolean(this._params.datainicial || this._params.datafinal)
  }
}

function initialState() {
  return {
    plot: new FaturamentoClientePlot(),
    filters: {
      startDate: null,
      endDate: null,
      limit: 10,
      sort: -1
    },
    options: {
      plotOptions: {
        bar: {
          horizontal: true
        }
      },
      dataLabels: {
        enabled: false
      },
      xaxis: {
        labels: {
          formatter: function(value) {
            return FormatService.formatNumber(value)
          }
        }
      },
      tooltip: {
        y: {
          formatter: function(value) {
            return FormatService.formatCurrency(value)
          }
        }
      }
    }
  }
}

export default {
  components: { BarPlot, PlotContainer, QDatePicker, QSlider, QSelect },
  props: {
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
  watch: {
    globalFilters: {
      handler(filters) {
        Object.assign(this.filters, filters)
        this.build()
      },
      deep: true
    }
  },
  sockets: {
    connect() {
      this.build()
    },
    refresh() {
      console.log('refresh CustomerRevenuePlot')
      this.build()
    }
  },
  mounted() {
    this.build()
  },
  methods: {
    onApplyFilters() {
      this.build()
    },
    build() {
      this.plot.params = {
        datainicial: this.filters.startDate,
        datafinal: this.filters.endDate,
        sort: this.filters.sort,
        limit: this.filters.limit
      }
    },
    onResetFilters() {
      this.filters = initialState().filters
    },
    onOpenFilters() {
      this.filters.startDate =
        this.plot.params.datainicial || initialState().filters.startDate
      this.filters.endDate =
        this.plot.params.datafinal || initialState().filters.endDate
      this.filters.sort = this.plot.params.sort || initialState().filters.sort
      this.filters.limit =
        this.plot.params.limit || initialState().filters.limit
    }
  }
}
</script>

<style lang="scss" scoped>
.filters {
  padding: 1.5rem;
  padding-bottom: 0;

  > * {
    margin-bottom: 1rem;
  }

  .filters__date-pickers {
    display: flex;

    .spacer {
      margin: 0.5rem;
    }
  }
}
</style>
