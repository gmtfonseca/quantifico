<template>
  <div class="plot-header">
    <v-toolbar dense flat :collapse="collapse">
      <v-toolbar-title class="plot-header__title">{{ title }}</v-toolbar-title>
      <v-spacer></v-spacer>

      <div v-if="!collapse">
        <PlotFilters
          v-model="showFilters"
          @open="onOpenFilters"
          @apply="onApplyFilters"
          @reset="onResetFilters"
        >
          <template v-slot:activator>
            <QTooltip v-slot="slotProps" text="Filtrar">
              <v-btn icon @click="onClickFilters" v-on="slotProps.on">
                <v-icon v-if="activeFilters">mdi-filter</v-icon>
                <v-icon v-else>mdi-filter-outline</v-icon>
              </v-btn>
            </QTooltip>
          </template>

          <template v-slot:body>
            <slot name="filters"></slot>
          </template>
        </PlotFilters>

        <QTooltip v-slot="slotProps" text="Favoritar">
          <v-btn icon v-on="slotProps.on">
            <v-icon>mdi-heart-outline</v-icon>
          </v-btn>
        </QTooltip>

        <PlotSettings v-model="showSettings">
          <template v-slot:activator>
            <QTooltip v-slot="slotProps" text="Configurações">
              <v-btn icon @click="onClickSettings" v-on="slotProps.on">
                <v-icon>mdi-dots-vertical</v-icon>
              </v-btn>
            </QTooltip>
          </template>
        </PlotSettings>
      </div>
    </v-toolbar>
  </div>
</template>

<script>
import PlotFilters from './PlotFilters'
import PlotSettings from './PlotSettings'
import { QTooltip } from '@/components/widgets/lib'

function initialState() {
  return {
    showFilters: false,
    showSettings: false
  }
}

export default {
  components: { PlotFilters, QTooltip, PlotSettings },
  props: {
    title: {
      type: String,
      required: true
    },
    collapse: {
      type: Boolean,
      default: false
    },
    activeFilters: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return initialState()
  },
  methods: {
    onClickFilters() {
      this.showFilters = true
    },
    onClickSettings() {
      this.showSettings = true
    },
    onResetFilters() {
      this.$emit('reset-filters')
    },
    onApplyFilters() {
      this.$emit('apply-filters')
    },
    onOpenFilters() {
      this.$emit('open-filters')
    }
  }
}
</script>

<style lang="scss" scoped>
.plot-header {
  border-bottom: 1px solid #ddd;
  &__title {
    font-size: 1rem;
    font-weight: bold;
    opacity: 0.75;
  }
}
</style>
