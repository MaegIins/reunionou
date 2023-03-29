import {createApp} from 'vue'
import router from './router'
import App from './App.vue'
import 'bootstrap/dist/css/bootstrap.min.css';


import 'bootstrap-icons/font/bootstrap-icons.css';
import VueGeolocation from "vue3-geolocation/src";

const app = createApp(App)
app.use(router)
app.use(VueGeolocation);



app.mount('#app')
