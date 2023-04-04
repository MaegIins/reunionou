<template>
  <div id="pplList">
    <h2>Participants</h2>
    <div id="everyPpl">

      <div class="people" id="organizer">
        <p>{{ organizer }}</p>
        <i class="bi bi-star-fill"></i>
      </div>
      <div v-for="person in listPpl" :key="person.id" id="pplin">

        <div v-if="person.status === 0" class="people" id="maybe">
          <p>{{ person.name_user }}</p>
          <i class="bi bi-question-circle"></i>
        </div>
        <div v-if="person.status === 1" class="people" id="coming">
          <p>{{ person.name_user }}</p>
          <i class="bi bi-check2"></i>
        </div>
        <div v-if="person.status === 2" class="people" id="notComing">
          <p>{{ person.name_user }}</p>
          <i class="bi bi-x-lg"></i>
        </div>

      </div>
    </div>
    <div v-if="sharedLink">
      <p>Lien d'invitation: <a :href="sharedLink" target="_blank">{{ sharedLink }}</a></p>
      <button @click="copyToClipboard"><i class="bi bi-clipboard"></i></button>
    </div>

    <button v-if="userEmail === orgaMail" @click="createInvitation"><i class="bi bi-plus"></i></button>
  </div>
</template>

<script>
import api from '../api';
import "./../assets/style/PresentComp.css";
export default {
  name: "PresentComp",
  props: ["listPpl", "organizer", "orgaMail", "userEmail"],
  methods: {
    async createInvitation() {
      try {
        const response = await api.get(`/events/${this.$route.params.id}/share`);
        this.sharedLink = window.location.origin + response.data.shared_uri;
      } catch (error) {
        console.log(error);
      }
    },
    copyToClipboard() {
      navigator.clipboard.writeText(this.sharedLink).then(() => {
        alert("Lien copié dans le presse-papiers !");
      }).catch((error) => {
        console.error("Erreur lors de la copie du lien :", error);
      });
    },
  },

  data() {
    return {
      sharedLink: "",
    };
  }

}

</script>

<style scoped></style>