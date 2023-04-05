<template>
    <div id="ListEvents">
        <router-link class="router" to="/accueil/">
            <h1>REUNIONOU.APP</h1>
        </router-link>

        <div id="pending-invitations">
            <h2>Invitations en attente</h2>
            <p v-if="pendingInvitations.length === 0">Aucune invitation en attente</p>

            <div id="messages">
                <p class="error-message">{{ errorMessage }}</p>
                <p class="confirm-message">{{ confirmMessage }}</p>
            </div>

            <div id="listInvit">
                <div v-for="invitation in pendingInvitations" :key="invitation.event.id_event" class="eventPending">
                    <h2>{{ invitation.event.name }}</h2>
                    <p>{{ invitation.event.description }}</p>
                    <p>{{ displayCorrectDate(invitation.event.date) }} à {{
                        displayCorrectTime(invitation.event.date)
                    }}</p>

                    <textarea v-model="invitation.comment" placeholder="Commentaire"></textarea>
                    <div class="invitation-actions">
                        <button @click="confirmInvite(invitation.event.id_event, true, invitation.comment)">Accepter
                        </button>
                        <button id="noButton"
                            @click="confirmInvite(invitation.event.id_event, false, invitation.comment)">Refuser
                        </button>
                    </div>
                </div>
            </div>

        </div>

        <div id="events">
            <div id="title">
                <h2>Mes évènements</h2>
                <button @click="this.$router.push('/newreunion')"><i class="bi bi-plus" /></button>
            </div>


            <div id="map"></div>

            <div id="eventsDiv">

                <div v-for="event in eventsSorted" :key="event.event.id_event">
                    <router-link class="router" :to="`/events/${event.event.id_event}`">
                        <div class="event" v-if="isDatePassed(event.event.date)">
                            <h2>{{ event.event.name }}</h2>
                            <p>{{ event.event.description }}</p>
                            <p>{{ displayCorrectDate(event.event.date) }} {{ displayCorrectTime(event.event.date) }}</p>
                        </div>
                        <div class="event" id="oldEvent" v-else>
                            <h2>{{ event.event.name }}</h2>
                            <p>{{ event.event.description }}</p>
                            <p>{{ displayCorrectDate(event.event.date) }} {{ displayCorrectTime(event.event.date) }}</p>
                        </div>
                    </router-link>
                    <div v-if="event.status === 0" class="invitation-actions">
                        <textarea v-model="event.comment" placeholder="Ajoutez un commentaire..."></textarea>
                        <button @click="confirmInvite(event.event.id_event, true, event.comment)">Accepter</button>
                        <button @click="confirmInvite(event.event.id_event, false, event.comment)">Refuser</button>
                    </div>
                </div>

            </div>


        </div>

        <logout-comp />
    </div>
</template>


<script>
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import api from '../api';
import "./../assets/style/ListEvents.css";
import LogoutComp from "@/components/LogoutComp.vue";




export default {
    name: "ListEvents",
    components: { LogoutComp },
    data() {
        return {
            events: [],
            pendingInvitations: [],
            errorMessage: '',
            confirmMessage: '',
        }
    },
    async mounted() {
        await this.getEvents();
        this.getPendingInvitations();
        this.initLeafletMap();
    },

    computed: {
        /**
         * Sort events by date
         * @returns {[]}
         */
        eventsSorted() {
            return this.events.sort((a, b) => {
                const dateA = new Date(a.event.date);
                const dateB = new Date(b.event.date);

                return dateA - dateB;
            });
        },
    },
    methods: {
        /**
         * Redirect to event page
         * @param idEvent
         */
        redirectToEvent(idEvent) {
            this.$router.push(`/events/${idEvent}`);
        },

        /**
         * Get pending invitations
         * @returns {Promise<void>}
         */
        async getPendingInvitations() {
            try {
                const response = await api.get('/invites/list', { params: { state: 0 } });
                this.pendingInvitations = response.data.events;
            } catch (error) {
                this.errorMessage = "Aucune invitation en attente";
                console.log(error);
            }
        },


        /**
         * Get events
         * @returns {Promise<void>}
         */
        async getEvents() {
            try {
                const response = await api.get('/events');
                this.events = response.data.events;
            } catch (error) {
                console.log(error);
            }
        },

        /**
         * Display date in correct format
         * @param date {string} Date to display
         * @returns {string} Date in correct format
         */
        displayCorrectDate(date) {
            const parsedDate = new Date(date);
            const day = parsedDate.getUTCDate().toString().padStart(2, '0');
            const month = (parsedDate.getUTCMonth() + 1).toString().padStart(2, '0');
            const year = parsedDate.getUTCFullYear();
            return day + '/' + month + '/' + year;
        },
        /**
         * Display time in correct format
         * @param date {string} Time to display
         * @returns {string} Time in correct format
         */
        displayCorrectTime(date) {
            const parsedDate = new Date(date);
            const hours = parsedDate.getUTCHours().toString().padStart(2, '0');
            const minutes = parsedDate.getUTCMinutes().toString().padStart(2, '0');
            return hours + ':' + minutes;
        },

        /**
         * Check if date is passed
         * @param date {string} Date to check
         * @returns {boolean} True if date is passed, false otherwise
         */
        isDatePassed(date) {
            const dateToCheck = new Date(date);
            const today = new Date();
            return dateToCheck > today;
        },
        /**
         * Confirm invite
         * @param eventId {number} Id of the event
         * @param status {boolean} Status of the invite
         * @param comment {string} Comment of the invite
         * @returns {Promise<void>}
         */
        async confirmInvite(eventId, status, comment) {
            // if (!comment) {
            //     this.errorMessage = 'Veuillez ajouter un commentaire';
            //     return;
            // }

            try {
                const response = await api.post('/invites/confirm/user', {
                    event: eventId,
                    status: status,
                    comment: comment,
                });

                if (response.data.type === 'success') {
                    this.errorMessage = '';
                    const updatedEvent = this.events.find((event) => event.event.id_event === eventId);
                    updatedEvent.status = status ? 1 : 2;
                    this.confirmMessage = response.data.message;
                    this.getPendingInvitations();
                    this.getEvents();
                } else {
                    console.error('Erreur lors de la confirmation de l\'invitation:', response.data.message);
                }
            } catch (error) {
                console.error('Erreur lors de la confirmation de l\'invitation:', error);
            }
        },
        initLeafletMap() {
            const map = L.map('map').setView([48.69345, 6.18237], 13);

            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
                maxZoom: 18,
            }).addTo(map);

            this.events.forEach((event) => {
                const lat = event.event.place.lat;
                const lon = event.event.place.lon;
                const eventName = event.event.name;

                const marker = L.marker([lat, lon]).addTo(map);
                marker.bindPopup(`<b>${eventName}</b>`);
            });
        },
    },
};

</script>

<style scoped>

#map {
    height: 300px; /* Définir la hauteur de la carte */
    margin-bottom: 1rem;
}

#pending-invitations {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    grid-gap: 1rem;
    color: white;
}

.event {
    background-color: #333;
    padding: 1rem;
    border-radius: 5px;
    position: relative;
}

.invitation-actions {
    display: flex;
    justify-content: space-between;
    margin-top: 1rem;
}

.error-message {
    color: red;
    margin-bottom: 1rem;
}

textarea {
    margin-bottom: 10px;
}

#oldEvent {
    background-color: #555;
}

#events {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    grid-gap: 1rem;
    color: white;
}

.router {
    text-decoration: none;
    color: white;
}

.router:hover {
    text-decoration: underline;
}
</style>