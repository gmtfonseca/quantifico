<template>
  <v-dialog
    ref="dialog"
    v-model="modal"
    :return-value.sync="computedDate"
    width="290px"
  >
    <template v-slot:activator="{ on }">
      <v-text-field
        v-model="formattedDate"
        :label="label"
        prepend-icon="mdi-calendar-range"
        readonly
        v-on="on"
      ></v-text-field>
    </template>
    <v-date-picker v-model="computedDate" scrollable>
      <v-spacer></v-spacer>
      <v-btn text color="primary" @click="onOk">OK</v-btn>
      <v-btn text @click="onClear">Limpar</v-btn>
      <v-btn text @click="onCancel">Cancelar</v-btn>
    </v-date-picker>
  </v-dialog>
</template>

<script>
import FormatService from '@/services/FormatService'

export default {
  props: {
    value: {
      type: String,
      default: null
    },
    label: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      modal: false
    }
  },
  computed: {
    formattedDate: {
      get() {
        if (this.value) {
          return FormatService.formatDate(this.value)
        }

        return null
      }
    },
    computedDate: {
      get() {
        return this.value
      },
      set(value) {
        this.$emit('input', value)
      }
    }
  },
  methods: {
    onClear() {
      this.computedDate = null
    },
    onOk() {
      this.$refs.dialog.save(this.computedDate)
    },
    onCancel() {
      this.modal = false
    }
  }
}
</script>

<style scoped></style>
