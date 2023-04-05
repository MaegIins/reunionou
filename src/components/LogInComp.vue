<template>
  <div id="login">
    <router-link to="/accueil">Retour à l'accueil</router-link>
    <h1>Connexion</h1>
    <input ref="mail" v-model="email" placeholder="Adresse mail" @keydown.enter="setFocusOnPwd"/>
    <input ref="pwd" type="password" v-model="password" placeholder="Mot de passe" @keydown.enter="logIn"/>
    <button v-on:click="logIn">Se Connecter</button>
    <router-link to="/signup">Pas encore de compte?</router-link>

    <p id="error" v-if="showLoginError">{{ loginError }}</p>
    <p id="good" v-if="showLoginSuccess">Login successful!</p>
  </div>
</template>

<script>
import api from "../api";
import "../assets/style/loginComp.css"

export default {
  name: "LogInComp",
  mounted() {
    this.setFocusOnMail();
  },
  data() {
    return {
      email: "",
      password: "",
      showLoginError: false,
      loginError: "",
      showLoginSuccess: false,
    };
  },
  methods: {
      /**
       * Set focus on mail input
       */
    setFocusOnMail() {
      this.$refs.mail.focus();
    },
      /**
       * Set focus on password input
       */
    setFocusOnPwd() {
      this.$refs.pwd.focus();
    },
      /**
       * Log in
       */
    logIn() {
      api
        .post(
          "auth/signin",
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
            this.$router.push("/accueil");
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

<style scoped>

</style>