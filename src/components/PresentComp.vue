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
    <div v-if="sharedLink" class="modal" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Lien d'invitation</h5>
            <button type="button" class="close" @click="closeModal">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
  <p class="link-container"><a :href="sharedLink" target="_blank">{{ sharedLink }}</a></p>
</div>
          <div class="modal-footer">
            <button type="button" class="btn btn-primary" @click="copyToClipboard"><i class="bi bi-clipboard"></i></button>
          </div>
        </div>
      </div>
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
    closeModal() {
      this.sharedLink = "";
    },
  },

  data() {
    return {
      sharedLink: "",
    };
  }

}

</script>

<style scoped>

.modal-title {
  color: black;
}
.modal {
  display: block;
  position: fixed;
  z-index: 1;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
}

.modal-dialog {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.modal-content {
  background-color: white;
  padding: 20px;
  border-radius: 4px;
  width: 90%;
  max-width: 500px;
}

.link-container {
  word-break: break-all;
  overflow-wrap: break-word;
}
</style>