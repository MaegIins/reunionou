<template>
  <div id="NewEvent">
    <router-link class="router" to="/accueil/">
      <h1>REUNIONOU.APP</h1>
    </router-link>
    <div id="form">
      <select v-model="selectOptions">
        <option disabled value="">Choisissez une option</option>
        <option v-for="option in options" :value="option.value">{{ option.label }}</option>
      </select>
      <input type="text" id="name" name="name" placeholder="Nom de la réunion">
      <input type="text" id="description" name="description" placeholder="Description">
      <input type="date" id="date" name="date">
      <input type="text" id="address" name="address" placeholder="Adresse">
      <button type="submit">Créer la réunion</button>

    </div>
  </div>
</template>

<script>
import axios from "axios";
import "./../assets/style/NewEvent.css";
export default {
  name: "NewEvent",
  data() {
    return {
      selectOptions: '',
      options: [],
      email: "",
      password: "",
      showLoginError: false,
      loginError: "",
      showLoginSuccess: false,
    };
  },
  methods: {
    getPlace() {
      axios
        .post(
          "http://localhost:3333/auth/signin",
          {
            email: this.email,
            password: this.password,
          },
          {
            auth: {
              username: this.email,
              password: this.password,
            },
          }
        )
        .then((response) => {
          if (response.status === 200) {
            this.showLoginSuccess = true;
            this.showLoginError = false;

            sessionStorage.setItem("access_token", response.data.access_token);
            sessionStorage.setItem("refresh_token", response.data.refresh_token);
            // this.$router.push("/");
          } else {
            this.showLoginSuccess = false;
            this.showLoginError = true;
            this.loginError = "Login failed. Please check your email and password.";
          }
        })
        .catch((error) => {
          console.log(error);
          this.showLoginSuccess = false;
          this.showLoginError = true;
          this.loginError = "An error occurred. Please try again later.";
        });
    },
  },
}





</script>

<style scoped></style>