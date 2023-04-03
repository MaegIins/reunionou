<template>
  <div id="NewEvent">
    <router-link class="router" to="/accueil/">
      <h1>REUNIONOU.APP</h1>
    </router-link>
    <form @submit.prevent="postEvent">

      <label for="my-select">Lieu de l'événement</label>
      <select v-model="selectOptions" id="my-select">
        <option disabled value="">Choisissez une option</option>
        <option v-for="option in options" :value="option.value">{{ option.label }}</option>
      </select>
      <br>
      <label for="name">Nom de la réunion :</label>
      <input type="text" id="name" name="name" v-model="title" placeholder="Nom de la réunion">
      <br>
      <label for="description">Description :</label>
      <input type="text" id="description" name="description" v-model="descr" placeholder="Description">
      <br>
      <label for="date">Date :</label>
      <input type="date" id="date" name="date" v-model="date.date">
      <input type="time" id="time" name="time" v-model="date.time">
      <br>
      <div v-if="selectOptions === 'newPlace'">
        <label for="address">Adresse :</label>
        <input type="text" id="street" name="street" v-model="adress.street" placeholder="Rue">
        <input type="text" id="city" name="city" v-model="adress.city" placeholder="Ville">
        <input type="text" id="name_place" name="name_place" v-model="name_place" placeholder="Nom du lieu">
      </div>
      <br>
      <button type="submit">Créer la réunion</button>
    </form>
    <p v-if="createEvent">Evenement créer !</p>
    <p v-if="requestInvalid">Tout les champs doivent etre renseignée</p>
    <p v-if="adressNotFound">Adresse introuvable</p>


  </div>
</template>

<script>
import api from '../api';
import "./../assets/style/NewEvent.css";
export default {
  name: "NewEvent",
  data() {
    return {
      selectOptions: '',
      options: [],
      title: "",
      descr: "",
      date: { date: "", time: "" },
      name_place: "",
      adress: { street: "", city: "" },
      createEvent: false,
      requestInvalid: false,
      adressNotFound: false
    };
  },
  methods: {
    async getPlace() {
      try {
        const response = await api.get(`/places`);
        const tableau2 = response.data.places.map(place => ({
          value: place.place.name,
          label: place.place.name
        }));
        tableau2.push({ value: 'newPlace', label: "Création d'un nouveau lieu" })
        this.options = tableau2

      } catch (error) {
        console.log(error);
      }
    },

    async postEvent() {
      try {
        let response
        this.createEvent = false
        this.requestInvalid = false
        this.requestInvalid = false
        if (this.selectOptions === "newPlace") {
          response = await api.post('/events', {
            title: this.title,
            description: this.descr,
            date: this.date,
            name_place: this.name_place,
            adress: { street: this.adress.street, city: this.adress.city }
          });
        } else {
          response = await api.post('/events', {
            title: this.title,
            description: this.descr,
            date: this.date,
            name_place: this.selectOptions,
            adress: { street: "test", city: "test" }
          });
        }

        if (response.status === 200) {
          this.createEvent = true;
        }

        this.name_place = ""
      } catch (error) {
        console.log(error.request.status)
        if (error.request.status === 400 || error.request.status === 500) {
          this.requestInvalid = true
        } else if (error.request.status === 404) {
          this.adressNotFound = true
        }
      }
    },
  },
  mounted() {
    this.getPlace();
  },
}





</script>

<style scoped></style>