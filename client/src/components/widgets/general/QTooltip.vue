<template>
  <span>
    <v-tooltip bottom>
      <template v-slot:activator="{ on }">
        <slot :on="on"></slot>
      </template>
      {{ text }}
    </v-tooltip>
  </span>
</template>

<script>
export default {
  props: {
    text: {
      type: String,
      required: true
    }
  }
}
</script>
