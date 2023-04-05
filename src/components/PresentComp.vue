<template>
    <div id="pplList">
        <h2>Participants</h2>
        <div id="everyPpl">

            <div class="people" id="organizer">
                <p>{{ organizer }} (<a :href="'mailto:' + orgaMail">{{ orgaMail }}</a>)</p>
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
                        <button type="button" class="btn btn-primary" @click="copyToClipboard"><i
                                class="bi bi-clipboard"></i></button>
                    </div>
                </div>
            </div>
        </div>

        <button v-if="userEmail === orgaMail" @click="createInvitation"><i class="bi bi-share"></i></button>

        <div v-if="userEmail === orgaMail" id="invite-user-form">
            <input v-model="inviteEmail" type="email" placeholder="Inviter un utilisateur existant (email)"/>
            <button @click="inviteExistingUser"><i class="bi bi-person-fill-add"></i></button>
        </div>

        <div v-if="errorMessage" class="error-message">{{ errorMessage }}</div>
        <div v-if="confirmMessage" class="success-message">{{ confirmMessage }}</div>

    </div>
</template>

<script>
import api from '../api';
import "./../assets/style/PresentComp.css";

export default {
    name: "PresentComp",
    props: ["listPpl", "organizer", "orgaMail", "userEmail"],
    methods: {
        /**
         * Invite un utilisateur existant à l'événement.
         * @returns {Promise<void>}
         */
        async inviteExistingUser() {
            this.errorMessage = ""; // Réinitialise le message d'erreur

            if (!this.inviteEmail) {
                this.errorMessage = "Veuillez entrer une adresse e-mail.";
                return;
            }

            try {
                const response = await api.post("/invites/user", {
                    mail: this.inviteEmail,
                    event: this.$route.params.id,
                });

                if (response.data.type === "success") {
                    this.listPpl.push(response.data.attendee);
                    this.inviteEmail = "";
                    this.confirmMessage = "L'utilisateur " + response.data.attendee.name_user + " a été invité à l'événement.";
                }
            } catch (error) {
                console.log(error);
                if (error.response.data.details === "attendee already exist") {
                    this.errorMessage = "Le participant est déjà invité à cet événement.";
                } else if (error.response.data.message.includes("is not orga of event")) {
                    this.errorMessage = "Vous n'êtes pas l'organisateur de cet événement.";
                } else if (error.response.data.message === "USER IS NOT EXIST") {
                    this.errorMessage = "L'utilisateur n'existe pas.";
                } else {
                    this.errorMessage = "Erreur lors de l'invitation de l'utilisateur.";
                }
            }
        },
        /**
         * Crée un lien d'invitation à l'événement.
         * @returns {Promise<void>}
         */
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
            inviteEmail: "",
            errorMessage: "",
            successMessage: "",
        };
    }

}

</script>

<style scoped>


.link-container {
    word-break: break-all;
    overflow-wrap: break-word;
}

.error-message {
    color: red;
    margin-top: 1rem;
}

.success-message {
    color: green;
    margin-top: 1rem;
}
</style>