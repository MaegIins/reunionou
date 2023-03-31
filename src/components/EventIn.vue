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

      const config = {
        headers: { Authorization: `Bearer ${sessionStorage.getItem("access_token")}` }
      };
      axios.get("http://localhost:3333/events/" + this.idEvent + "/attendees", config)
        .then((response) => {
          this.people = response.data
        })
        .catch((error) => {
          console.log(error)
        });

    },

    // faire la même chose que les participant pour les com, mettre les comments dans la gateway
    com(){

      const config = {
        headers: { Authorization: `Bearer ${sessionStorage.getItem("access_token")}` }
      };
      axios.get("http://localhost:3333/comments/events/" + this.idEvent, config)
        .then((response) => {
          this.comments = response.data
          console.log(response.data)
        })
        .catch((error) => {
          console.log(error)
        });

    },
  },
  mounted() {
    this.attendee(),
    this.com()
  },

  props: {},
  data() {
    return {
      logged: false,
      idEvent: this.$route.params.id,
      eventPosition: [48.8566, 2.3522],
      people: [],
      comments: [],

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