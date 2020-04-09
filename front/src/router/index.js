import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'

import BenevolesList from '../views/BenevolesList.vue'
import CompetencesCRF from '../views/CompetencesCRF.vue'
import CompetencesNonCRF from '../views/CompetencesNonCRF.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/about',
    name: 'About',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/About.vue')
  },
  {
    path: '/benevoles',
    name: 'BenevolesList',
    component: BenevolesList,
    meta: {
      requiresAuth: true,
      auth_roles: ['admin', 'DLUS', 'DLAS']
    },
    children: [
      {
        path: '/competences-crf',
        name: 'CompetencesCRF',
        component: CompetencesCRF,
        meta: {
          requiresAuth: true,
          auth_roles: ['admin', 'DLUS', 'DLAS']
        }
      },
      {
        path: '/competences-non-crf',
        name: 'CompetencesNonCRF',
        component: CompetencesNonCRF,
        meta: {
          requiresAuth: true,
          auth_roles: ['admin', 'DLUS', 'DLAS']
        }
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!localStorage.login) {
      next({
        path: '/',
        query: { redirect: to.fullPath }
      })
    } else {
      console.log(localStorage.role)
      console.log(to)
      if (to.meta.auth_roles.indexOf(localStorage.role) >= 0) {
        next()
      } else {
        next({
          path: '/',
          query: { redirect: to.fullPath }
        })
      }
    }
  } else {
    next() // make sure to always call next()!
  }
})

export default router
