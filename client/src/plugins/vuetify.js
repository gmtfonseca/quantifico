import Vue from 'vue'
import Vuetify from 'vuetify/lib'
import pt from 'vuetify/es5/locale/pt'

Vue.use(Vuetify)

export default new Vuetify({
  lang: {
    locales: { pt },
    current: 'pt'
  },
  theme: {
    themes: {
      light: {
        primary: '#7159C1',
        // primary: '#3700b5',
        secondary: '#F3F2F1',
        accent: '#8c9eff',
        error: '#b71c1c'
      }
    }
  }
})
