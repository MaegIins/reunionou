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
    <ul class="event-list">
      <li v-for="(event, index) in events" :key="index">
        {{ event.name }} - {{ event.description }} - {{ event.date }}
      </li>
    </ul>
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
      marker: null,
      events: [], // add an empty array for events
      map: null, // add a data property for the map object
    }
  },
  mounted() {
    // create a map and assign it to the data property
    this.map = L.map('map').setView([48.8566, 2.3522], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors'
    }).addTo(this.map);

    // add marker
    this.marker = L.marker([48.8566, 2.3522]).addTo(this.map);

    this.showEventsOnMap(this.marker);

    this.map.on('click', (e) => {
      const { lat, lng } = e.latlng;
      this.marker.setLatLng([lat, lng]);
      this.showEventForm = true;
    });
  },
  methods: {
    createEvent() {
      const { lat, lng } = this.marker.getLatLng();
      const newEvent = {
        name: this.eventName,
        description: this.eventDescription,
        date: this.eventDate,
        lat: lat,
        lng: lng
      };
      this.events.push(newEvent); // add the new event to the events array
      this.eventName = '';
      this.eventDescription = '';
      this.eventDate = '';
      this.showEventForm = false;
      console.log('New Event:', newEvent);
      this.showEventsOnMap(this.map); // call the method to show events on the map and pass the map object
    },
    showEventsOnMap(map) {
      this.events.map(event => {
        const { lat, lng, name, description, date } = event;
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