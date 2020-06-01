<template>
  <div class="wrapper"></div>
</template>

<script>
export default {
  name: 'Dashboard'
}
</script>

<style lang="scss" scoped>
@import '@/config/device.scss';

.wrapper {
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
