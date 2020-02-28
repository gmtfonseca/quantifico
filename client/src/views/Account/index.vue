<template>
  <div>
    <v-card>
      <v-list>
        <v-list-item>
          <v-list-item-avatar>
            <img src="https://cdn.vuetifyjs.com/images/john.jpg" alt="John" />
          </v-list-item-avatar>

          <v-list-item-content>
            <v-list-item-title>Gustavo Fonseca</v-list-item-title>
            <v-list-item-subtitle>gustavo@gmail.com</v-list-item-subtitle>
            <v-list-item-subtitle><b>Quantifico</b></v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-card>

    <div class="account-options">
      <AccountOption
        icon="mdi-factory"
        title="Dados da organização"
        description="Visualize e atualize dados da sua organização"
      />

      <AccountOption
        icon="mdi-account-card-details-outline"
        title="Informações pessoais"
        description="Dados pertencentes a sua conta de usuário"
      />

      <AccountOption
        icon="mdi-account-lock"
        title="Login e segurança"
        description="Atualize seu e-mail e senha"
      />

      <AccountOption
        icon="mdi-poll-box"
        title="Meus indicadores"
        description="Visualize e atualize seus indicadores favoritos"
      />

      <AccountOption
        icon="mdi-cash-multiple"
        title="Pagamentos"
        description="Revise seus pagamentos"
      />

      <AccountOption
        icon="mdi-credit-card"
        title="Atualizar cartão de crédito"
        description="Atualize seu cartão para pagamentos futuros"
      />
    </div>
  </div>
</template>

<script>
import AccountOption from './AccountOption'

export default { components: { AccountOption } }
</script>

<style lang="scss" scoped>
@import '@/config/device.scss';

.account-options {
  display: grid;
  grid-template-columns: 100%;
  padding: 2.5rem 1rem;
  align-items: center;
  justify-content: center;

  @media (min-width: $tablet) {
    grid-template-columns: 50% 50%;
  }

  @media (min-width: $desktop) {
    grid-template-columns: auto auto auto;
  }
}
</style>
