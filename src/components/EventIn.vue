<template>
  <div id="EventIn">

    <router-link to="/accueil">
      <h1>REUNIONOU.APP</h1>
    </router-link>

    <div id="elements">


      <PresentComp :listPpl="people"></PresentComp>
      <CommentsComp :comments="comments"></CommentsComp>

      <div>
        <MapComp :eventPos="eventPosition"></MapComp>
      </div>
    </div>

    <button @click="attendee">Tester la méthode attendee</button>

  </div>
</template>

<script>
import axios from "axios";
import "./../assets/style/EventIn.css";
import router from "@/router";
import PresentComp from "@/components/PresentComp.vue";
import CommentsComp from "@/components/CommentsComp.vue";


import MapComp from "@/components/MapComp.vue";


export default {
  name: "EventIn",
  components: { CommentsComp, PresentComp, MapComp, Map },
  methods: {
    router() {
      return router
    },
    sendComment() {
      console.log("sendComment")
    },

    attendee() {
      axios
        .get("http://localhost:3333/events/"+this.idEvent+"/attendees", {
          headers:{'Authorization': 'Bearer ' + sessionStorage.getItem("acces-token")}
        })
        .then((response) => {
          if (response.status === 200 || response.status === 201) {
            this.confirmMessage = "Votre compte a bien été créé.";
            this.showConfirmMessage = true;
          } else {
            this.serverError = "Merci de renseigner tous les champs correctement.";
            this.showServerError = true;
          }
        })
        .then(data => {
          console.log(data.json)
        })
        .catch((error) => {
          if (error.response.status === 422) {
            this.validationError = "Des champs sont manquants ou invalides.";
            this.showValidationErrors = true;
          } else {
            this.serverError = "Merci de renseigner tous les champs correctement.";
            this.showServerError = true;
          }
        });
    },



  },

  props: {},
  data() {
    return {
      logged: false,
      idEvent: this.$route.params.id,
      eventPosition: [48.8566, 2.3522],
      people: [
        { id: 1, name: "Jean", ok: 1 },
        { id: 2, name: "Pierre", ok: 2 },
        { id: 3, name: "Paul", ok: 3 },
        { id: 4, name: "Jacques", ok: 1 },
        { id: 5, name: "Marie", ok: 2 },
        { id: 6, name: "Jeanne", ok: 3 },
        { id: 7, name: "Pierre", ok: 1 },
        { id: 8, name: "Paul", ok: 2 },
        { id: 9, name: "Jacques", ok: 3 },
      ],
      comments: [{
        id: 1, name: "Jean", comment: "Je suis là !",
        date: "13:23 12/12/2020"
      },
      {
        id: 2, name: "Pierre", comment: "Je ne serai pas là !",
        date: "13:23 12/12/2020"
      },
      {
        id: 3, name: "Paul", comment: "Je ne sais pas encore !",
        date: "13:23 12/12/2020"
      },
      {
        id: 4, name: "Jacques", comment: "Je suis là !",
        date: "13:23 12/12/2020"
      },
      {
        id: 5, name: "Marie", comment: "Je ne serai pas là !",
        date: "13:23 12/12/2020"
      },
      {
        id: 6, name: "Jeanne", comment: "Je ne sais pas encore !",
        date: "13:23 12/12/2020"
      },
      {
        id: 7, name: "Pierre", comment: "Je suis là !",
        date: "13:23 12/12/2020"
      },
      {
        id: 8, name: "Paul", comment: "Je ne serai pas là !",
        date: "13:23 12/12/2020"
      },
      {
        id: 9, name: "Jacques", comment: "Je ne sais pas encore !",
        date: "13:23 12/12/2020"
      }
      ],

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