<template>
  <div>
    <h1>LogIn</h1>
    <input v-model="email" placeholder="EMAIL"/>
    <input v-model="password" placeholder="PASSWORD"/>
    <button v-on:click="logIn">LOG IN</button>

    <p v-if="showLoginError">{{ loginError }}</p>
    <p v-if="showLoginSuccess">Login successful!</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "LogInComp",
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
    logIn() {
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

            sessionStorage.setItem("access_token", response.access_token);
            sessionStorage.setItem("refresh_token", response.refresh_token);
            this.$router.push("/");
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