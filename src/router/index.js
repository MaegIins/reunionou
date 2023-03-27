
 import {createRouter, createWebHistory} from "vue-router";
/**
 import AddSharedAccount from "@/components/AddSharedAccount.vue";
 import AllSharedAccount from "@/components/AllSharedAccount.vue";
 import ErrorFourOFour from "@/components/ErrorFourOFour.vue";
 import InsideSharedAccount from "@/components/InsideSharedAccount.vue";
 */
import AccueilApp from "@/components/AccueilApp.vue";
import Map from "@/components/Map.vue";

const routes = [
    {name: 'AllSharedAccount', path: '/', component: AccueilApp},
    {name: 'TEST', path: '/Map', component: Map },
    //{name: 'InsideSharedAccount', path: '/accounts/:id', component: },



    //{name: 'Error404', path: '/:pathMatch(.*)*', component: ErrorFourOFour}
]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

export default router