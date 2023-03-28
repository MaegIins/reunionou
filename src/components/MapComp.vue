<template>
  <div class="map-container">
    <div id="map"></div>
    <div class="event-form" v-if="showEventForm">
      <button class="close-btn" @click="showEventForm = false"><i class="fas fa-times"></i></button>
      <h2>Create Event</h2>
      <form @submit.prevent="createEvent">
        <label for="name">Name:</label>
        <input type="text" id="name" v-model="eventName" required>
        <label for="description">Description:</label>
        <textarea id="description" v-model="eventDescription"></textarea>
        <label for="date">Date:</label>
        <input type="date" id="date" v-model="eventDate" required>
        <button type="submit">Create</button>
      </form>
    </div>

  </div>
</template>

<script>

import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

export default {
  name: 'MapComp',
  props: [
    'eventPos'
  ],

  data() {
    return {

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
    this.map = L.map('map').setView([48.8566, 2.3522], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors'
    }).addTo(this.map);


    this.marker = L.marker(this.eventPos).addTo(this.map);
    console.log(this.eventPosLat, this.eventPosLng);




    this.map.on('click', (e) => {
      const {lat, lng} = e.latlng;
      this.marker.setLatLng([lat, lng]);
      this.showEventForm = true;
    });
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


          this.showEventsOnMap(this.marker);


        })
        .catch((error) => {
          console.log(error);
        });


  },
  //METHODS SECTION
  methods: {

    showEventsOnMap(map) {
      this.events.map(event => {
        const {lat, lng, name, description, date} = event;
        console.log(lat, lng, name, description, date);
        const popupContent = `
            <h2>${name}</h2>
            <p>${description}</p>
            <p>${date}</p>
`;
        const eventMarker = L.marker([lat, lng]).addTo(map);
        eventMarker.bindPopup(popupContent);
      });
    }
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