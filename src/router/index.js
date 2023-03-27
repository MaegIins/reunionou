
 import {createRouter, createWebHistory} from "vue-router";
/**
 import AddSharedAccount from "@/components/AddSharedAccount.vue";
 import AllSharedAccount from "@/components/AllSharedAccount.vue";
 import ErrorFourOFour from "@/components/ErrorFourOFour.vue";
 import InsideSharedAccount from "@/components/InsideSharedAccount.vue";
 */
import AccueilApp from "@/components/AccueilApp.vue";


const routes = [
    {name: 'AllSharedAccount', path: '/', component: AccueilApp},
   // {name: 'AddSharedAccount', path: '/newAccount', component: },
    //{name: 'InsideSharedAccount', path: '/accounts/:id', component: },



    //{name: 'Error404', path: '/:pathMatch(.*)*', component: ErrorFourOFour}
]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

export default router