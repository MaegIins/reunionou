<template>
    <div id="inviteComp">
        <h1 @click="this.$router.push('/accueil')">REUNIONOU.APP</h1>

        <div>
            <h2>Vous êtes invité à un évènement</h2>
            <h3>{{ eventName }}</h3>
            <h4>{{ formatDate(eventDate) }}</h4>

            <p>{{ description }}</p>

            <div id="boutons">
                <div>
                    <button @click="">Je viens !</button>
                    <button @click="">Je ne viens pas</button>
                </div>
            </div>

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
    name: "InviteComp",
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


        getEventByInvit() {
            api
                .get("/invites", { params: { key: this.key } })
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
    },
    computed: {
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
  