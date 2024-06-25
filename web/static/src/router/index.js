import { createRouter, createWebHashHistory } from "vue-router";

const routes = [
  {
    path: "/",
    component: () => import("@/page/layout.vue"),
    redirect: "/home",
    children: [
      {
        path: "home",
        name: "home",
        component: () => import("@/page/home/index.vue"),
      },
    ],
  },
  {
    path: "/pair/:id",
    component: () => import("@/page/layout.vue"),
    children: [
      {
        path: "",
        name: "pair",
        component: () => import("@/page/pair/index.vue"),
      },
    ],
  },
  {
    path: "/install/:id",
    component: () => import("@/page/layout.vue"),
    children: [
      {
        path: "",
        name: "install",
        component: () => import("@/page/install/index.vue"),
      },
    ],
  },
  {
    path: "/settings",
    component: () => import("@/page/layout.vue"),
    children: [
      {
        path: "",
        name: "settings",
        component: () => import("@/page/settings/index.vue"),
      },
    ],
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
