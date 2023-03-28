<template>
  <div id="EventIn">

    <router-link to="/accueil"><h1>REUNIONOU.APP</h1></router-link>

    <div id="elements">


      <div id="pplList">
        <h2>Participants</h2>
        <div id="everyPpl">
          <div v-for="person in people" :key="person.id" id="pplin">

            <div v-if="person.ok === 1" class="people" id="coming">
              <p>{{ person.name }}</p>
              <i class="bi bi-check2"></i>
            </div>
            <div v-if="person.ok === 2" class="people" id="notComing">
              <p>{{ person.name }}</p>
              <i class="bi bi-x-lg"></i>
            </div>
            <div v-if="person.ok === 3" class="people" id="maybe">
              <p>{{ person.name }}</p>
              <i class="bi bi-question-circle"></i>
            </div>
          </div>
        </div>

        <button><i class="bi bi-plus"></i></button>
      </div>
      <div id="comments">
        <h2>Commentaires</h2>
        <div id="listComs">


          <div v-for="comment in comments" :key="comment.id" id="comment">
            <div id="commentHeader">
              <p>{{ comment.name }}</p>
              <p>{{ comment.date }}</p>
            </div>
            <div id="commentBody">
              <p>{{ comment.comment }}</p>
            </div>
          </div>
        </div>
        <div id="commentForm">
          <form>
            <textarea placeholder="Ajouter un commentaire..."></textarea>
            <button v-on:click="sendComment"><i class="bi bi-send"></i></button>
          </form>
        </div>
      </div>
      <div>
        <MapComp eventPos="eventPosistion"></MapComp>
      </div>
    </div>

  </div>


</template>

<script>
import "./../assets/style/EventIn.css";
import router from "@/router";

import MapComp from "@/components/MapComp.vue";


export default {
  name: "EventIn",
  components: {MapComp, Map},
  methods: {
    router() {
      return router
    },
    sendComment() {
      console.log("sendComment")
    }
  },

  props: {},
  data() {
    return {
      logged: false,
      idEvent: this.$route.params.id,
      eventPosition: [48.8566, 2.3522],
      people: [
        {id: 1, name: "Jean", ok: 1},
        {id: 2, name: "Pierre", ok: 2},
        {id: 3, name: "Paul", ok: 3},
        {id: 4, name: "Jacques", ok: 1},
        {id: 5, name: "Marie", ok: 2},
        {id: 6, name: "Jeanne", ok: 3},
        {id: 7, name: "Pierre", ok: 1},
        {id: 8, name: "Paul", ok: 2},
        {id: 9, name: "Jacques", ok: 3},
      ],
      comments: [{
        id: 1, name: "Jean", comment: "Je suis là !",
        date: Date()
      },
        {
          id: 2, name: "Pierre", comment: "Je ne serai pas là !",
          date: Date()
        },
        {
          id: 3, name: "Paul", comment: "Je ne sais pas encore !",
          date: Date()
        }],

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