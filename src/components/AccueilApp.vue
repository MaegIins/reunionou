<template>
    <div class="accueil">


        <div id="main">
            <h1>REUNIONOU.app</h1>
            <h2>Reunionou.app est une application qui permet à des groupes de personnes (famille, amis,
                groupe de collègues) de se fixer un rendez-vous en un lieu déterminé et d'organiser ce rendez-vous.</h2>
            <div v-if="logged">
                <button @click="this.$router.push('/newreunion')">Nouvel évènement</button>
                <button @click="this.$router.push('/liste')">Mes Évènements</button>
            </div>
            <div v-else>
                <button @click="this.$router.push('/login')">Nouvel évènement</button>
            </div>

        </div>


        <div class="login">
            <div v-if="logged">
                <logout-comp/>
            </div>
            <div v-else>
                <a @click="this.$router.push('/login')">SE CONNECTER</a>
                <p>|</p>
                <a @click="this.$router.push('/signup')">S'INSCRIRE</a>
            </div>
        </div>


    </div>
</template>

<script>
import "./../assets/style/accueil.css";
import router from "@/router";
import LogoutComp from "@/components/LogoutComp.vue";

export default {
    name: "AccueilApp",
    methods: {
        router() {
            return router
        }
    },
    components: {LogoutComp},
    props: {},
    data() {
        return {
            logged: true,
        };
    },
    mounted() {
        if (sessionStorage.getItem("access_token") === null) {
            this.logged = false;
        } else {
            this.logged = true;
        }
    }
}
</script>

<style scoped>

</style>