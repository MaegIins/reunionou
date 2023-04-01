import {createRouter, createWebHistory} from "vue-router";
/**
 import AddSharedAccount from "@/components/AddSharedAccount.vue";
 import AllSharedAccount from "@/components/AllSharedAccount.vue";
 import ErrorFourOFour from "@/components/ErrorFourOFour.vue";
 import InsideSharedAccount from "@/components/InsideSharedAccount.vue";
 */
import AccueilApp from "@/components/AccueilApp.vue";
import EventIn from "@/components/EventIn.vue";
import LogInComp from "@/components/LogInComp.vue";
import SignUpComp from "@/components/SignUpComp.vue";
import ListEvents from "@/components/ListEvents.vue";
import NewEvent from "@/components/NewEvent.vue";

const routes = [
    {name: 'Main', path: '/', component: AccueilApp},
    {name: 'AccueilApp', path: '/accueil', component: AccueilApp},
    {name: 'InsideEvent', path: '/reunion/:id', component: EventIn},
    {name: 'LogIn', path: '/login', component: LogInComp},
    {name: 'SignUp', path: '/signup', component: SignUpComp},
    {name: 'ListEvents', path: '/liste/:idUser', component: ListEvents},
    {name: 'NewReunion', path: '/newreunion', component: NewEvent}



    //{name: 'Error404', path: '/:pathMatch(.*)*', component: ErrorFourOFour}
]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

export default router