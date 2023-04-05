<template>
    <div id="inviteComp">
        <h1 @click="this.$router.push('/accueil')">REUNIONOU.APP</h1>
        <div v-if="errorMessage">
            <h2>{{ errorMessage }}</h2>
        </div>
        <div v-else id="content">
            <div>
                <h2>Vous êtes invité à un évènement</h2>
                <h3 id="title">{{ eventName }} </h3>
                <p>Organisé par {{ organizerName }} ({{ organizerEmail }})</p>
                <h4>Le {{ formatDate(eventDate) }}</h4>

                <p>Description : {{ description }}</p>

                <div v-if="!showForm" id="buttons-primary">
                    <button @click="showConfirmationForm(true)">Je confirme ma présence</button>
                    <button id="noButton" @click="showConfirmationForm(false)">Je ne viens pas</button>
                </div>

                <div id="form" v-if="showForm">
                    <div id="namail">

                        <input type="text" id="name" v-model="name" placeholder="Nom" required/>
                        <input type="email" id="mail" v-model="mail" placeholder="Adresse Mail" required/>
                    </div>

                    <textarea id="comment" v-model="comment" placeholder="Commentaire" required></textarea>

                    <div id="buttons">

                        <button type="submit" @click="confirm">Envoyer</button>
                        <button id="noButton" @click="showForm = false">Annuler</button>
                    </div>
                </div>

                <div v-if="responseMessage">{{ responseMessage }}</div>
            </div>


            <div class="map-container">
                <h2>Lieu de la réunion</h2>
                <div id="map"></div>
            </div>
        </div>

        <logout-comp/>
    </div>
</template>

<script>
import api from "@/api.js";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import LogoutComp from "@/components/LogoutComp.vue";
import "../assets/style/inviteComp.css"

export default {
    name: "InviteComp",
    components: {LogoutComp},
    data() {
        return {
            idEvent: this.$route.params.id,
            eventName: "",
            eventDate: "",
            description: "",
            organizerName: "",
            organizerEmail: "",
            people: [],
            comments: [],
            namePlace: "",
            adressPlace: "",
            map: null,
            name: "",
            mail: "",
            comment: "",
            showForm: false,
            attending: false,
            responseMessage: "",
            errorMessage: "",
        };
    },
    methods: {
        /**
         * Méthode qui permet de formater la date
         * @param dateString date a formater
         * @returns {string} date formatée
         */
        formatDate(dateString) {
            const date = new Date(dateString);
            const fullDayinFrench = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"];
            const day = fullDayinFrench[date.getDay()];
            const getDay = date.getDate().toString().padStart(2, "0");
            const fullMonthinFrench = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"];
            const month = fullMonthinFrench[date.getMonth()];
            const year = date.getFullYear();
            const options = {
                timeZone: "Etc/GMT",
                hour: "numeric",
                minute: "2-digit",
                hour12: false
            };
            const formattedDate = date.toLocaleString("fr-FR", options).replace(":", "h");
            const [hours, minutes] = formattedDate.split("h");

            return `${day} ${getDay} ${month} ${year} à ${hours}h${minutes}`;
        },

        /**
         * Méthode qui permet de récupérer les informations de l'évènement
         */
        getEventByInvit() {
            api
                .get("/invites", {params: {key: this.key}})
                .then((response) => {
                    this.eventName = response.data.event.name;
                    this.description = response.data.event.description;
                    this.eventDate = response.data.event.date;
                    this.organizerName = response.data.event.name_orga;
                    this.organizerEmail = response.data.event.mail_orga;
                    this.namePlace = response.data.event.place.name;
                    this.adressPlace = response.data.event.place.adress;
                    this.eventPosition = [
                        response.data.event.place.lat,
                        response.data.event.place.lon,
                    ];
                    this.showEventOnMap();
                })
                .catch((error) => {
                    console.log(error);
                    if (error.response) {
                        this.errorMessage = "L'invitation est expirée ou invalide.";
                    } else {
                        this.errorMessage = "Une erreur est survenue. Veuillez réessayer.";
                    }
                });
        },

        /**
         * Méthode qui permet d'afficher la carte
         */
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
        /**
         * Méthode qui permet d'afficher le formulaire de confirmation
         * @param attending boolean qui permet de savoir si l'utilisateur confirme sa présence ou non
         */
        showConfirmationForm(attending) {
            this.showForm = true;
            this.attending = attending;
        },

        /**
         * Méthode qui permet d'envoyer la confirmation de présence ou d'absence
         */
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
                    this.showForm = false;
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
        /**
         * Méthode qui permet d'accéder au paramètre de requête key
         * @returns {*} paramètre de requête key
         */
        key() {
            // Accéder au paramètre de requête key
            return this.$route.query.key;
        },
    },
    mounted() {

        console.log("La clé est :", this.key);
        this.getEventByInvit();
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
  