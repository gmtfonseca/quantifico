<template>
  <PlotContainer
    title="FATURAMENTO MENSAL"
    :plot="plot"
    @apply-filters="onApplyFilters"
    @reset-filters="onResetFilters"
    @open-filters="onOpenFilters"
  >
    <template v-slot:filters>
      <div class="filters">
        <QComboNumber
          v-model="filters.years"
          hint="Máximo de 4 anos"
          label="Anos"
          :validation="yearsValidation"
          :counter="4"
        >
        </QComboNumber>
      </div>
    </template>
    <template v-slot:body>
      <LinePlot :series="plot.series" :options="options" />
    </template>
  </PlotContainer>
</template>

<script>
import HttpService from '@/services/HttpService'
import PlotContainer from '@/components/plots/shared/PlotContainer'
import LinePlot from '@/components/plots/models/LinePlot'
import FormatService from '@/services/FormatService'
import Plot from '@/components/plots/shared/Plot'
import { required } from 'vuelidate/lib/validators'

import { QComboNumber } from '@/components/widgets/lib'

class FaturamentoMensalPlot extends Plot {
  async getSeries() {
    const httpService = new HttpService('nfs/plot/faturamento-mensal')
    const response = await httpService.get(this._params)

    const years = new Map()
    response.data.map(record => {
      if (!years.has(record.ano)) {
        years.set(record.ano, new Map())
      }

      years.get(record.ano).set(record.mes, record.totalFaturado)
    })

    const series = []
    for (const year of years.keys()) {
      const data = this.fillEmptyMonths(years.get(year))
      series.push({
        name: year,
        data: data
      })
    }

    return series
  }

  fillEmptyMonths(year) {
    const data = []
    for (let m = 1; m <= 12; m++) {
      if (year.has(m)) {
        data.push(year.get(m))
      } else {
        data.push(0)
      }
    }
    return data
  }

  get hasActiveFilters() {
    return Boolean(this._params.anos)
  }
}

function initialState() {
  return {
    plot: new FaturamentoMensalPlot(),
    filters: {
      years: [new Date().getFullYear()]
    },
    options: {
      xaxis: {
        categories: [
          'Jan',
          'Fev',
          'Mar',
          'Abr',
          'Mai',
          'Jun',
          'Jul',
          'Ago',
          'Set',
          'Out',
          'Nov',
          'Dez'
        ],
        title: {
          text: 'Mês'
        }
      },
      yaxis: {
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
  components: { LinePlot, PlotContainer, QComboNumber },
  data() {
    return initialState()
  },
  computed: {
    yearsValidation() {
      const errors = []
      if (!this.$v.filters.years.$dirty) return errors

      !this.$v.filters.years.required &&
        errors.push('Informe pelo menos um ano')
      return errors
    }
  },
  validations: {
    filters: {
      years: {
        required
      }
    }
  },
  sockets: {
    connect() {
      this.build()
    },
    refresh() {
      console.log('refresh MonthlyRevenuePlot')
      this.build()
    }
  },
  mounted() {
    this.build()
  },
  methods: {
    onApplyFilters() {
      this.$v.$touch()

      if (!this.$v.$invalid) {
        this.build()
      }
    },
    build() {
      this.plot.params = {
        anos: this.filters.years.slice(0, 4).join(',')
      }
    },
    onResetFilters() {
      this.filters = initialState().filters
    },
    onOpenFilters() {
      this.filters.years =
        this.plot.params.anos.split(',') || initialState().filters.years
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
}
</style>
