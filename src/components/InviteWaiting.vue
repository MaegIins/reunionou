<template>
    <div id="inviteComp">
        <h1 @click="this.$router.push('/accueil')">REUNIONOU.APP</h1>
        <div v-if="errorMessage">
            <h2>{{ errorMessage }}</h2>
        </div>
        <div v-else>

            <h2>Vous êtes invité à un évènement</h2>
            <h3>{{ eventName }}</h3>
            <p>Organisé par {{ organizerName }} ({{ organizerEmail }})</p>
            <h4>Le {{ formatDate(eventDate) }}</h4>

            <p>Description : {{ description }}</p>

            <div v-if="!showForm">
                <button @click="showConfirmationForm(true)">Je confirme ma présence</button>
                <button @click="showConfirmationForm(false)">Je ne viens pas</button>
            </div>

            <form v-if="showForm" @submit.prevent>
                <label for="name">Nom :</label>
                <input type="text" id="name" v-model="name" required />

                <label for="mail">E-mail :</label>
                <input type="email" id="mail" v-model="mail" required />

                <label for="comment">Détails :</label>
                <textarea id="comment" v-model="comment" required></textarea>

                <button type="submit" @click="confirm">Envoyer</button>
            </form>

            <div v-if="responseMessage">{{ responseMessage }}</div>

            <div class="map-container">
                <h2>Lieu de la réunion</h2>
                <div id="map"></div>
            </div>
        </div>
    </div>
</template>
  
<script>
import api from "@/api.js";
import L from "leaflet";
import "leaflet/dist/leaflet.css";

export default {
    name: "InviteWaiting",
    data() {
        return {
            invites: [],
            idEvent: this.$route.params.id,
            responseMessage: "",
            errorMessage: "",
        };
    },
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


        getInvites() {
            api
                .get("/invites/list", { params: { state: 0 } })
                .then((response) => {
                    this.invites = response.data;
                    this.showEventOnMap();
                })
                .catch((error) => {
                    console.log(error);
                });
        },

        showEventOnMap() {
            this.map = L.map("map").setView(this.eventPosition, 13);
            L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
                attribution:
                    '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
            }).addTo(this.map);

            const eventMarker = L.marker(this.eventPosition).addTo(this.map);
            eventMarker
                .bindPopup(`<h2>${this.namePlace}</h2><p>${this.adressPlace}</p>`)
                .openPopup();
        },
        showConfirmationForm(attending) {
            this.showForm = true;
            this.attending = attending;
        },

        async confirm() {
            try {
                const response = await api.post("/invites/confirm", {
                    key: this.key,
                    status: this.attending,
                    name: this.name,
                    mail: this.mail,
                    comment: this.comment,
                });

                if (response.status >= 400) {
                    this.responseMessage = "Une erreur est survenue. Veuillez réessayer.";
                } else if (response.data.type === "success") {
                    this.responseMessage = `Confirmation ${this.attending ? "de présence" : "d'absence"
                        } envoyée avec succès.`;
                } else {
                    this.responseMessage = "Une erreur est survenue. Veuillez réessayer.";
                }
            } catch (error) {
                console.log(error);
                this.responseMessage = "Une erreur est survenue. Veuillez réessayer.";
            }
        },
    },
    computed: {
    },
    mounted() {
        this.getInvites();
    },
};
</script>
  
<style scoped>
.map-container {
    height: 500px;
    width: 500px;
}

#map {
    height: 100%;
}
</style>
  