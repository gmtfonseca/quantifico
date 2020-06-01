import Vue from 'vue'
import VueRouter from 'vue-router'
import store from '../store'
import Panel from '../views/Panel.vue'
import Plots from '../views/Plots.vue'

const originalPush = VueRouter.prototype.push
VueRouter.prototype.push = function push(location) {
  // eslint-disable-next-line
	return originalPush.call(this, location).catch(err => {})
}

Vue.use(VueRouter)

const checkAuth = (to, from, next) => {
  if (store.getters.isLoggedIn) {
    next()
  } else {
    next({ name: 'login' })
  }
}

const routes = [
  {
    path: '/login',
    name: 'login',
    component: () =>
      import(/* webpackChunkName: "login" */ '../views/Login.vue')
  },
  {
    path: '/panel',
    name: 'panel',
    component: Panel,
    beforeEnter: checkAuth,
    children: [
      {
        name: 'dashboard',
        path: 'dashboard',
        meta: {
          label: 'Dashboard'
        },
        component: () =>
          import(/* webpackChunkName: "dashboard" */ '../views/Dashboard.vue')
      },
      {
        name: 'nf',
        path: 'nf',
        meta: {
          label: 'Notas Fiscais'
        },
        component: () =>
          import(/* webpackChunkName: "plot" */ '../views/Nf.vue')
      },
      {
        name: 'account',
        path: 'account',
        meta: {
          label: 'Gerenciar Conta'
        },
        component: () =>
          import(/* webpackChunkName: "plot" */ '../views/Account')
      },
      {
        path: 'plots',
        name: 'plots',
        component: Plots,
        children: [
          {
            name: 'saidas',
            path: 'saidas',
            meta: {
              label: 'Indicadores de Saídas'
            },
            component: () =>
              import(/* webpackChunkName: "saida" */ '../views/Saidas.vue')
          },
          {
            name: 'entradas',
            path: 'entradas',
            meta: {
              label: 'Indicadores de Entradas'
            },
            component: () =>
              import(/* webpackChunkName: "entrada" */ '../views/Entradas.vue')
          }
        ]
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
