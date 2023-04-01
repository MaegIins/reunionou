<template>
  <div id="NewEvent">
    <router-link class="router" to="/accueil/"><h1>REUNIONOU.APP</h1></router-link>
    <div id="form">

        <input type="text" id="name" name="name" placeholder="Nom de la réunion">
        <input type="text" id="description" name="description" placeholder="Description">
        <input type="date" id="date" name="date">
        <input type="text" id="address" name="address" placeholder="Adresse">
        <button type="submit">Créer la réunion</button>

    </div>
  </div>
</template>

<script>
import axios from "axios";
import "./../assets/style/NewEvent.css";
export default {
  name: "NewEvent"
}
</script>

<style scoped>

</style>