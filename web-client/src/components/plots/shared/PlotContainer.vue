<template>
  <v-skeleton-loader :loading="showLoading" type="list-item, divider, image">
    <v-card class="plot-container">
      <PlotHeader
        v-show="showHeader"
        class="plot-container__header"
        :active-filters="plot.hasActiveFilters"
        :collapse="hasError"
        :title="title"
        @apply-filters="onApplyFilters"
        @reset-filters="onResetFilters"
        @open-filters="onOpenFilters"
      >
        <template v-slot:filters>
          <slot name="filters"></slot>
        </template>
      </PlotHeader>

      <div class="plot-container__body">
        <div v-if="hasError" class="plot-container__plot--error">
          <PlotError @refresh="onRefresh" />
        </div>
        <div v-else class="plot-container__plot-wrapper">
          <div v-if="isEmpty" class="plot-container__plot--empty">
            <QAlert>Sem dados</QAlert>
          </div>
          <slot v-else name="body" class="plot-container__plot"></slot>
        </div>
      </div>
    </v-card>
  </v-skeleton-loader>
</template>

<script>
import PlotHeader from './PlotHeader'
import PlotError from './PlotError'
import { PlotState } from './Plot'
import { QAlert } from '@/components/widgets/lib'

export default {
  components: { PlotHeader, PlotError, QAlert },
  props: {
    title: {
      type: String,
      required: true
    },
    plot: {
      type: Object,
      required: true
    }
  },
  computed: {
    showHeader() {
      return this.plot.state !== PlotState.LOADING
    },
    showLoading() {
      return this.plot.state === PlotState.LOADING
    },
    isEmpty() {
      return this.plot.empty
    },
    hasError() {
      return this.plot.state === PlotState.ERROR
    }
  },
  methods: {
    onRefresh() {
      this.plot.build()
    },
    onApplyFilters() {
      this.$emit('apply-filters')
    },
    onResetFilters() {
      this.$emit('reset-filters')
    },
    onOpenFilters() {
      this.$emit('open-filters')
    }
  }
}
</script>

<style lang="scss" scoped>
.plot-container {
  padding: 0;
  height: 100%;
  display: flex;
  flex-direction: column;

  .plot-container__body {
    min-height: 10rem;
    flex: 1;

    .plot-container__plot-wrapper {
      min-height: inherit;
      height: 100%;
    }

    .plot-container__plot--empty,
    .plot-container__plot--error {
      min-height: inherit;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
    }
  }
}
</style>
