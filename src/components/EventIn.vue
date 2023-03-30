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
        headers: { Authorization: `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywibmFtZSI6IlF1ZW50aW4iLCJtYWlsIjoicXVlbnRpbkBpdXQuZnIiLCJpYXQiOjE2ODAxODgxOTgsImV4cCI6MTY4MDE5MTc5OH0.dfnlFKQWBB30OP4v85RZ9ZtFkeqTZzxATP9SPArPmDg` }
      };
      axios.get("http://localhost:3333/events/" + this.idEvent + "/attendees", config)
        .then((response) => {
          this.people = response.data
          console.log(response.data)
        })
        .catch((error) => {
          console.log(error)
        });

    },

    //faire la même chose que les participant pour les com, mettre les comments dans la gateway
    // comments() {

    //   const config = {
    //     headers: { Authorization: `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywibmFtZSI6IlF1ZW50aW4iLCJtYWlsIjoicXVlbnRpbkBpdXQuZnIiLCJpYXQiOjE2ODAxODgxOTgsImV4cCI6MTY4MDE5MTc5OH0.dfnlFKQWBB30OP4v85RZ9ZtFkeqTZzxATP9SPArPmDg` }
    //   };
    //   axios.get("http://localhost:3333/events/" + this.idEvent + "/attendees", config)
    //     .then((response) => {
    //       this.people = response.data
    //       console.log(response.data)
    //     })
    //     .catch((error) => {
    //       console.log(error)
    //     });

    // },
  },
  mounted() {
    this.attendee()
  },

  props: {},
  data() {
    return {
      logged: false,
      idEvent: this.$route.params.id,
      eventPosition: [48.8566, 2.3522],
      people: [],
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