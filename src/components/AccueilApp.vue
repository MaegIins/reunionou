<template>
  <div class="accueil">


    <div id="main">
      <h1>REUNIONOU.app</h1>
      <div v-if="logged">
        <button @click="this.$router.push('/newreunion')">NOUVELLE RÉUNION</button>
        <button @click="this.$router.push('/liste/')">MES RÉUNIONS</button>
      </div>
      <div v-else>
        <button @click="this.$router.push('/login')">NOUVELLE RÉUNION</button>
      </div>

    </div>


    <div class="login">
      <div v-if="logged">
        <a @click="logout()">SE DÉCONNECTER</a>
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
export default {
  name: "AccueilApp",
  methods: {
    logout() {
      sessionStorage.removeItem("access_token");
      sessionStorage.removeItem("refresh_token");
      this.$router.push('/login');
    },
    router() {
      return router
    }
  },
  components: {},
  props: {},
  data() {
    return {
      logged : true,
    };
  },
}
</script>

<style scoped>

</style>