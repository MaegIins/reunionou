<template>
  <div id="NewEvent">
    <router-link class="router" to="/accueil/">
      <h2>REUNIONOU.APP</h2>
    </router-link>
    <div class="newEventForm">
      <h1>Créer une réunion</h1>

      <select v-model="selectOptions" id="my-select">
        <option disabled value="">Choisissez une option</option>
        <option v-for="option in options" :value="option.value">{{ option.label }}</option>
      </select>

      <input type="text" id="name" name="name" v-model="title" placeholder="Nom de la réunion">
      <input type="text" id="description" name="description" v-model="descr" placeholder="Description">
      <div id="time">
        <input type="date" id="date" name="date" v-model="date.date" v-bind:min="currentDate">
        <input type="time" id="time" name="time" v-model="date.time">
      </div>
      <div id="adrs" v-if="selectOptions === 'newPlace'">
        <input type="text" id="street" name="street" v-model="adress.street" placeholder="Rue">
        <input type="text" id="city" name="city" v-model="adress.city" placeholder="Ville">
        <input type="text" id="name_place" name="name_place" v-model="name_place" placeholder="Nom du lieu">
      </div>
      <button @click="postEvent">Créer la réunion</button>
      <button @click="this.$router.push('/accueil')">Retour à l'accueil</button>

      <p v-if="createEvent" class="ok">Evenement créé !</p>
      <p v-if="requestInvalid" class="error">Tout les champs doivent être renseignés</p>
      <p v-if="adressNotFound" class="error">Adresse introuvable</p>
    </div>

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
      adressNotFound: false,
      currentDate: new Date().toISOString().substr(0, 10)
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
      let response
      this.createEvent = false
      this.requestInvalid = false
      this.requestInvalid = false


      if (this.selectOptions === "newPlace") {
        try {
          response = await api.post('/events', {
            title: this.title,
            description: this.descr,
            date: this.date,
            name_place: this.name_place,
            adress: { street: this.adress.street, city: this.adress.city }
          });

          if (response.status === 200) {
            this.createEvent = true;
            console.log(response)
            this.$router.push("/events/" + response.data.event.id_event);
          }
        } catch (error) {
          if (error.request.status === 400 || error.request.status === 500) {
            this.requestInvalid = true
          } else if (error.request.status === 404) {
            this.adressNotFound = true
          }
        }

      } else {
        try {
          response = await api.post('/events', {
            title: this.title,
            description: this.descr,
            date: this.date,
            name_place: this.selectOptions,
            adress: { street: "test", city: "test" }
          });

          if (response.status === 200) {
            this.createEvent = true;
            console.log(response)
            this.$router.push("/events/" + response.data.event.id_event);
          }
        } catch (error) {
          if (error.request.status === 400 || error.request.status === 500) {
            this.requestInvalid = true
          } else if (error.request.status === 404) {
            this.adressNotFound = true
          }
        }
      }



      this.name_place = ""
      if (error.request.status === 400 || error.request.status === 500) {
        this.requestInvalid = true
      } else if (error.request.status === 404) {
        this.adressNotFound = true
      }
    }
  },
  mounted() {
    this.getPlace();
  },
}


</script>

<style scoped></style>