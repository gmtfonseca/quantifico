<template>
  <div class="wrapper">
    <div class="login-container">
      <QLinearProgress v-show="waitingResponse" />
      <div class="company-logo">
        <img src="@/assets/logo.png" alt="" />
      </div>
      <form class="user-form" autocomplete="none" @submit.prevent="onSubmit">
        <QInput
          ref="email"
          v-model="form.email"
          :validation="emailValidation"
          label="Email"
        />
        <QPasswordInput
          ref="password"
          v-model="form.password"
          :validation="passwordValidation"
          label="Senha"
        />

        <span class="user-form__forgot-password">
          Esqueceu sua senha?
        </span>

        <QPrimaryButton
          class="user-form__submit"
          text="Entrar"
          type="submit"
          @click="onSubmit"
        ></QPrimaryButton>
      </form>
    </div>
  </div>
</template>

<script>
import HttpService from '@/services/HttpService'
import {
  QInput,
  QPasswordInput,
  QLinearProgress,
  QPrimaryButton
} from '@/components/widgets/lib'
import { required, email } from 'vuelidate/lib/validators'

function initialState() {
  return {
    userService: new HttpService('sessao'),
    form: {
      email: 'alex@gmail.com',
      password: ''
    },
    modal: false,
    waitingResponse: false,
    unauthorizedUser: false
  }
}

export default {
  name: 'Login',
  components: {
    QPasswordInput,
    QPrimaryButton,
    QLinearProgress,
    QInput
  },
  validations: {
    form: {
      email: {
        required,
        email
      },
      password: {
        required
      }
    }
  },
  data() {
    return initialState()
  },
  computed: {
    emailValidation() {
      const errors = []
      if (!this.$v.form.email.$dirty) return errors

      !this.$v.form.email.email && errors.push('E-mail inválido')
      !this.$v.form.email.required && errors.push('Informe o seu email')
      return errors
    },
    passwordValidation() {
      const errors = []
      if (!this.$v.form.password.$dirty) return errors

      !this.$v.form.password.required && errors.push('Informe a sua senha')
      this.unauthorizedUser && errors.push('Senha incorreta')
      return errors
    }
  },
  methods: {
    onChange(email) {
      this.email = email
    },
    onSubmit() {
      this.$v.$touch()

      if (!this.$v.$invalid) {
        this.submit()
      }
    },
    async submit() {
      try {
        this.waitingResponse = true
        this.unauthorizedUser = false
        await this.$store.dispatch('login', this.form)
        this.$router.push({ name: 'dashboard' })
      } catch (e) {
        this.unauthorizedUser = e.response.status == 401
        console.log(e.response)
      } finally {
        this.waitingResponse = false
      }
    },
    logout() {
      this.$store.dispatch('logout')
    }
  }
}
</script>

<style lang="scss" scoped>
@import '@/config/device.scss';

.wrapper {
  display: flex;
  height: 100%;
}

.login-container {
  width: 25rem;
  margin: auto;

  @media (min-width: $tablet) {
    border: 1px solid #ddd;
  }
}

.company-logo {
  width: 5rem;
  margin: auto;

  img {
    margin-top: 2rem;
    width: 100%;
  }
}

.user-form {
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 3rem;

  .user-form__submit {
    margin-top: 2rem;
  }

  .user-form__forgot-password {
    display: block;
    margin-left: auto;
    margin-top: 1rem;
    font-size: 0.8rem;
  }
}
</style>
