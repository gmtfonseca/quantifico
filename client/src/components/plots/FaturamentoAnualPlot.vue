<template>
  <PlotContainer
    title="FATURAMENTO ANUAL"
    :plot="plot"
    @apply-filters="onApplyFilters"
    @reset-filters="onResetFilters"
    @open-filters="onOpenFilters"
  >
    <template v-slot:filters>
      <div class="filters">
        <div class="filters__years">
          <QInputNumber
            v-model="filters.startYear"
            hint="AAAA"
            label="Ano inicial"
          />
          <span class="spacer"></span>
          <QInputNumber
            v-model="filters.endYear"
            hint="AAAA"
            label="Ano final"
          />
        </div>
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

import { QInputNumber } from '@/components/widgets/lib'

class FaturamentoAnualPlot extends Plot {
  async getSeries() {
    const httpService = new HttpService('nfs/plot/faturamento-anual')
    const response = await httpService.get(this._params)

    const data = response.data.map(record => {
      return {
        x: record.ano ? String(record.ano) : 'Outro',
        y: record.totalFaturado
      }
    })

    const series = [{ name: 'Total Faturado', data }]
    return series
  }

  get hasActiveFilters() {
    return Boolean(this._params.anoinicial || this._params.anofinal)
  }
}

function initialState() {
  return {
    plot: new FaturamentoAnualPlot(),
    filters: {
      startYear: null,
      endYear: null
    },
    options: {
      colors: ['#f90e49'],
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
  components: { BarPlot, PlotContainer, QInputNumber },
  data() {
    return initialState()
  },
  sockets: {
    connect() {
      this.build()
    },
    refresh() {
      console.log('refresh AnnualRevenuePlot')
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
        anoinicial: this.filters.startYear,
        anofinal: this.filters.endYear
      }
    },
    onResetFilters() {
      this.filters = initialState().filters
    },
    onOpenFilters() {
      this.filters.startYear =
        this.plot.params.anoinicial || initialState().filters.startYear
      this.filters.endYear =
        this.plot.params.anofinal || initialState().filters.endYear
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

  .filters__years {
    display: flex;

    .spacer {
      margin: 0.5rem;
      display: inline-block;
    }
  }
}
</style>
