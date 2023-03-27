<template>
  <div class="accueil">


    <div id="main">
      <h1>REUNIONOU.app</h1>
      <div v-if="logged">
        <button>NOUVELLE RÉUNION</button>
        <button>MES RÉUNIONS</button>
      </div>
      <div v-else>
        <button>NOUVELLE RÉUNION</button>
      </div>

    </div>


    <div class="login">
      <div v-if="logged">
        <a href="#">SE DÉCONNECTER</a>
      </div>
      <div v-else>
        <a href="#">SE CONNECTER</a>
        <p>|</p>
        <a href="#">S'INSCRIRE</a>
      </div>
    </div>


  </div>
</template>

<script>
import "./../assets/style/accueil.css";
export default {
  name: "AccueilApp",
  components: {},
  props: {},
  data() {
    return {
      logged : false,
    };
  },
}
</script>

<style scoped>

</style>