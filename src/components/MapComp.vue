<template>
  <div class="map-container">
    <h2>Lieu de la réunion</h2>
    <div id="map"></div>
  </div>
</template>

<script>
import axios from "axios";
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import '../assets/style/mapComp.css';

export default {
  name: 'MapComp',
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
      eventPosLat: this.eventPos[0],
      eventPosLng: this.eventPos[1],
    }
  },
  mounted() {
    // create a map and assign it to the data property
    this.map = L.map('map').setView([48.69247152298754, 6.184081448030852], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors'
    }).addTo(this.map);

    this.marker = L.marker(this.eventPos).addTo(this.map);
    console.log(this.eventPosLat, this.eventPosLng);

    this.map.on('click', (e) => {
      const { lat, lng } = e.latlng;
      this.marker.setLatLng([lat, lng]);
      this.showEventForm = true;
    });

    // Load the event data and display it on the map
    this.loadEvent();
  },
  //Created SECTION
  created() {
    this.$getLocation()
      .then((coordinates) => {
        this.position = coordinates;
        this.latU = coordinates.lat;
        this.lngU = coordinates.lng;

        this.marker = L.marker([this.latU, this.lngU]).addTo(this.map);
        console.log(this.latU, this.lngU);
      })
      .catch((error) => {
        console.log(error);
      });
  },
  //METHODS SECTION
  methods: {
    loadEvent() {
      const config = {
        headers: { Authorization: `Bearer ${sessionStorage.getItem("access_token")}` }
      };
      axios.get("http://localhost:3333/events/" + this.idEvent, config)
        .then((response) => {
          this.events = response.data;
          this.showEventOnMap();
        })
        .catch((error) => {
          console.log(error);
        });
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