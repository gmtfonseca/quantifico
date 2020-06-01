<template>
  <div>
    <div class="plots-container">
      <FaturamentoClientePlot :global-filters="globalFilters" />
      <FaturamentoCidadePlot :global-filters="globalFilters" />
      <FaturamentoMensalPlot />
      <FaturamentoAnualPlot />
      <FaturamentoProdutoPlot />
    </div>

    <PlotGlobalFilters
      v-model="showGlobalFilters"
      :global-filters="globalFilters"
      @apply="onApplyGlobalFilters"
    >
      <template v-slot:activator="slotProps">
        <v-btn color="primary" fixed fab dark bottom right v-on="slotProps.on">
          <v-icon>mdi-filter</v-icon>
        </v-btn>
      </template>
    </PlotGlobalFilters>
  </div>
</template>

<script>
import PlotGlobalFilters from '@/components/plots/shared/PlotGlobalFilters'
import FaturamentoClientePlot from '@/components/plots/FaturamentoClientePlot'
import FaturamentoCidadePlot from '@/components/plots/FaturamentoCidadePlot'
import FaturamentoMensalPlot from '@/components/plots/FaturamentoMensalPlot'
import FaturamentoAnualPlot from '@/components/plots/FaturamentoAnualPlot'
import FaturamentoProdutoPlot from '@/components/plots/FaturamentoProdutoPlot'

function initialState() {
  return {
    showGlobalFilters: false,
    globalFilters: {
      startDate: null,
      endDate: null
    }
  }
}

export default {
  components: {
    PlotGlobalFilters,
    FaturamentoClientePlot,
    FaturamentoCidadePlot,
    FaturamentoMensalPlot,
    FaturamentoAnualPlot,
    FaturamentoProdutoPlot
  },
  data() {
    return initialState()
  },
  methods: {
    onApplyGlobalFilters(globalFilters) {
      Object.assign(this.globalFilters, globalFilters)
    }
  }
}
</script>

<style lang="scss" scoped>
@import '@/config/device.scss';

.plots-container {
  display: flex;
  flex-direction: column;

  > * {
    margin-bottom: 1rem;
  }

  @media (min-width: $laptop) {
    display: grid;
    grid-template-columns: 50% 50%;
    gap: 1rem;
    padding-right: 1rem;

    > * {
      margin-bottom: 0;
    }
  }
}
</style>
