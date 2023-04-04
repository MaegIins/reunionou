<template>
  <div class="map-container">
    <h2>Lieu de la réunion</h2>
    <div id="map"></div>
  </div>
</template>

<script>
import api from '../api';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import '../assets/style/mapComp.css';

export default {
  name: 'MapCompInvite',
  props: [
    'eventPos'
  ],

  data() {
    return {
      idEvent: this.$route.params.id,
      position: null,
      marker: null,
      events: [], // add an empty array for events
      map: null, // add a data property for the map object
    }
  },
  mounted() {
    this.loadEvent();
  },
  methods: {
    

    async loadEvent() {
      try {
        const response = await api.get('/events/' + this.idEvent);
        this.events = response.data;
        this.showEventOnMap();
      } catch (error) {
        console.log(error);
      }
    },

    showEventOnMap() {
      const event = this.events.event;
      const { lat, lon, name: placeName, adress } = event.place;
      const { name: eventName, description, date, name_orga } = event;
      console.log(event.place);
      const popupContent = `
  <h2>${placeName}</h2>
  <p>${adress}</p>
  <p>${description}</p>
  `;
      this.map = L.map('map').setView([lat, lon], 13);
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
      }).addTo(this.map);

      const eventMarker = L.marker([lat, lon]).addTo(this.map);
      eventMarker.bindPopup(popupContent).openPopup();
    },

  }
}
</script>


<style>
.map-container {
  height: 500px;
  width: 500px;
}

#map {
  height: 100%;
}

.event-form {
  position: absolute;
  top: 10px;
  left: 10px;
  background-color: white;
  padding: 10px;
  border-radius: 5px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
  z-index: 1000;
}
</style>