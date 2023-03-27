<template>
  <div class="map-container">
    <div id="map"></div>
    <div class="event-form" v-if="showEventForm">
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
  name: 'Map',
  data() {
    return {
      showEventForm: false,
      eventName: '',
      eventDescription: '',
      eventDate: '',
      marker: null // add a marker variable to the component's data
    }
  },
  mounted() {
    const map = L.map('map').setView([48.8566, 2.3522], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    this.marker = L.marker([48.8566, 2.3522]).addTo(map); // assign the marker to the component's data

    map.on('click', (e) => {
      const { lat, lng } = e.latlng;
      this.marker.setLatLng([lat, lng]); // use this.marker to update the marker's position

      this.showEventForm = true;
    });
  },
  methods: {
    createEvent() {
      const { lat, lng } = this.marker.getLatLng(); // use this.marker to get the marker's position
      const newEvent = {
        name: this.eventName,
        description: this.eventDescription,
        date: this.eventDate,
        lat: lat,
        lng: lng
      };
      console.log('New Event:', newEvent);
      this.eventName = '';
      this.eventDescription = '';
      this.eventDate = '';
      this.showEventForm = false;
    }
  }
};
</script>

<style>
.map-container {
  height: 500px;
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
  box-shadow: 0 0 10px rgba(0,0,0,0.3);
  z-index: 1000;
}
</style>
