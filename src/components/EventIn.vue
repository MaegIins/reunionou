<template>
  <div id="EventIn">

    <router-link to="/accueil">
      <h1>REUNIONOU.APP</h1>
    </router-link>
    <!-- <div id="boutons">
      <div>
        <button>Je viens !</button>
        <button>Je ne viens pas</button>
      </div>
    </div> -->
    <div v-if="errorMessage">
      <p>{{ errorMessage }}</p>
    </div>
    <div v-else id="content">

      <div id="event-details">
        <h2>{{ eventName }}</h2>
        <h3>{{ formatDate(eventDate) }}</h3>
      </div>
      <div id="elements">
        <PresentComp :listPpl="people" :organizer="organizerName" :orgaMail="organizerEmail" :userEmail="userEmail">
        </PresentComp>
        <CommentsComp :comments="comments" @send-comment="sendComment"></CommentsComp>

        <div>
          <MapComp :eventPos="eventPosition"></MapComp>
        </div>
      </div>
    </div>


  </div>
</template>

<script>
import api from '../api';
import "./../assets/style/EventIn.css";
import router from "@/router";
import PresentComp from "@/components/PresentComp.vue";
import CommentsComp from "@/components/CommentsComp.vue";


import MapComp from "@/components/MapComp.vue";


export default {
  name: "EventIn",
  components: { CommentsComp, PresentComp, MapComp, Map },
  methods: {
    formatDate(dateString) {
      const date = new Date(dateString);
      const fullDayinFrench = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"];
      const day = fullDayinFrench[date.getDay()];
      const getDay = date.getDate().toString().padStart(2, "0");
      const fullMonthinFrench = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"];
      const month = fullMonthinFrench[date.getMonth()];
      const year = date.getFullYear();
      const hours = date.getHours().toString().padStart(2, "0");
      const minutes = date.getMinutes().toString().padStart(2, "0");

      return `${day} ${getDay} ${month} ${year} à ${hours}h${minutes}`;
    },


    router() {
      return router
    },

    async userInfo() {
      try {
        const response = await api.get(`/auth/validate`);
        this.userName = response.data.name;
        this.userEmail = response.data.mail;
      } catch (error) {
        console.log(error);
        this.errorMessage = "Erreur lors de la récupération des informations utilisateur.";

      }
    },

    async fetchEventInfo() {
      try {
        const response = await api.get(`/events/${this.idEvent}`);
        this.eventName = response.data.event.name;
        this.eventDate = response.data.event.date;
        this.organizerEmail = response.data.event.mail_orga;
        this.organizerName = response.data.event.name_orga;
      } catch (error) {
        console.log(error);
        this.errorMessage = "Erreur lors de la récupération des informations de l'événement.";

      }
    },
    async sendComment(commentText) {
      try {
        const response = await api.post(`/comments/add`, {
          id_event: this.idEvent,
          text: commentText,
        });
        this.com();
      } catch (error) {
        console.log(error);
        this.errorMessage = "Erreur lors de l'envoi du commentaire.";

      }
    },

    async attendee() {
      try {
        const response = await api.get(`/events/${this.idEvent}/attendees`);
        this.people = response.data;
      } catch (error) {
        console.log(error);

      }
    },

    // faire la même chose que les participant pour les com, mettre les comments dans la gateway
    async com() {
      try {
        const response = await api.get(`/comments/events/${this.idEvent}`);
        this.comments = response.data;
      } catch (error) {
        console.log(error);
        this.errorMessage = "Erreur lors de la récupération de la liste des commentaires.";
      }
    },
  },
  mounted() {
    this.userInfo();
    this.fetchEventInfo(),
      this.attendee(),
      this.com()
  },

  props: {},
  data() {
    return {
      userName: "",
      userEmail: "",
      logged: false,
      idEvent: this.$route.params.id,
      eventPosition: [48.856614, 2.3522219],
      people: [],
      comments: [],
      eventName: "",
      eventDate: "",
      organizerEmail: "",
      organizerName: "",
      errorMessage: "",

    };
  }
}
</script>

<style scoped>
MapComp {
  height: 500px;
  width: 500px;
}
</style>