<template>
  <div id="ListEvents">
    <router-link class="router" to="/accueil/">
      <h1>REUNIONOU.APP</h1>
    </router-link>
    <router-link class="router" to="/newreunion/">
      <button>Créer un évènement</button>
    </router-link>

    <div id="events">
      <div v-for="event in eventsSorted">
        <router-link class="router" :to="event.links.self.href">
          <div class="event" v-if="isDatePassed(event.event.date)">
            <h2>{{ event.event.name }}</h2>
            <p>{{ event.event.description }}</p>
            <p>{{ displayCorrectDate(event.event.date) }}</p>
          </div>
          <div class="event" id="oldEvent" v-else>
            <h2>{{ event.event.name }}</h2>
            <p>{{ event.event.description }}</p>
            <p>{{ displayCorrectDate(event.event.date) }}</p>
          </div>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script>
import api from '../api';
import axios from "axios";
import "./../assets/style/ListEvents.css";

export default {
  name: "ListEvents",
  data() {
    return {
      events: []
    }
  },
  mounted() {
    this.getEvents();
  },

  computed: {
    eventsSorted() {
      return this.events.sort((a, b) => {
        const [jourA, moisA, anneeA] = a.event.date.split('/');
        const [jourB, moisB, anneeB] = b.event.date.split('/');
        const dateA = new Date(parseInt(anneeA), parseInt(moisA) - 1, parseInt(jourA));
        const dateB = new Date(parseInt(anneeB), parseInt(moisB) - 1, parseInt(jourB));
        return dateA - dateB;
      });
    },
  },
  methods: {
    async getEvents() {
      try {
        const response = await api.get('/events');
        this.events = response.data.events;
      } catch (error) {
        console.log(error);
      }
    },

    displayCorrectDate(date) {
      const [jour, mois, annee] = date.split('/');
      return jour + '/' + mois + '/' + annee;
    },
    //fonction qui permet de verifier que la date en parametre est passée ou non
    //si la date est passée, on retourn false
    //si la date n'est pas passée, on retourne true
    isDatePassed(date) {
      const [jour, mois, annee] = date.split('/');
      const dateToCheck = new Date(parseInt(annee), parseInt(mois) - 1, parseInt(jour));
      const today = new Date();
      return dateToCheck > today;
    }
  },
}
</script>

<style scoped></style>