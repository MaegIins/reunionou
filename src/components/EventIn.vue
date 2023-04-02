<template>
  <div id="EventIn">

    <router-link to="/accueil">
      <h1>REUNIONOU.APP</h1>
    </router-link>
    <div id="event-details">
      <h2>{{ eventName }}</h2>
      <h2>{{ formatDate(eventDate) }}</h2>
      <p>Organisateur : {{ organizerEmail }}</p>
    </div>


    <div id="boutons">
      <div>
        <button>Je viens !</button>
        <button>Je ne viens pas</button>
      </div>
    </div>

    <div id="elements">


      <PresentComp :listPpl="people"></PresentComp>
      <CommentsComp :comments="comments" @send-comment="sendComment"></CommentsComp>


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
    formatDate(dateString) {
      const date = new Date(dateString);
      const day = date.getDate().toString().padStart(2, "0");
      const month = (date.getMonth() + 1).toString().padStart(2, "0");
      const year = date.getFullYear();
      const hours = date.getHours().toString().padStart(2, "0");
      const minutes = date.getMinutes().toString().padStart(2, "0");

      return `${day}/${month}/${year} ${hours}h${minutes}`;
    },


    router() {
      return router
    },

    fetchEventInfo() {
      const config = {
        headers: { Authorization: `Bearer ${sessionStorage.getItem("access_token")}` }
      };
      axios.get("http://localhost:3333/events/" + this.idEvent, config)
        .then((response) => {
          this.eventName = response.data.event.name;
          this.eventDate = response.data.event.date;
          this.organizerEmail = response.data.event.mail_orga;
        })
        .catch((error) => {
          console.log(error);
        });
    },
    sendComment(commentText) {
      const commentData = {
        id_event: this.idEvent,
        text: commentText,
      };

      const config = {
        headers: { Authorization: `Bearer ${sessionStorage.getItem("access_token")}` },
      };

      axios
        .post("http://localhost:3333/comments/add", commentData, config)
        .then((response) => {
          this.comments.push(response.data);
          console.log('aaa', response.data);
        })
        .catch((error) => {
          console.log(error);
        });
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
    com() {

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
    this.fetchEventInfo(),
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
      eventName: "",
      eventDate: "",
      organizerEmail: "",

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