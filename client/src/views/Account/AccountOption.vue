<template>
  <v-card class="option">
    <div>
      <v-icon large>{{ icon }}</v-icon>
    </div>

    <span class="option__title">{{ title }}</span>
    <span class="option__description">{{ description }}</span>
  </v-card>
</template>

<script>
export default {
  props: {
    icon: {
      type: String,
      required: true
    },
    title: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    }
  }
}
</script>

<style lang="scss">
@import '@/config/device.scss';

.option {
  display: flex;
  flex-direction: column;
  padding: 1rem 2rem;
  margin: 0.4rem;
  height: 10rem;
  cursor: pointer;

  &__title {
    font-size: 1.2rem;
    font-weight: bold;
  }

  &__description {
    font-size: 0.9rem;
    font-weight: lighter;
  }

  @media (min-width: $desktop) {
    width: 22rem;
  }
}
</style>
