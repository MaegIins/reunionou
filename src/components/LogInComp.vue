<template>
  <div>
    <h1>LogIn</h1>
    <input v-model="name" placeholder="USERNAME"/>
    <input v-model="password" placeholder="PASSWORD"/>
    <button v-on:click="logIn">LOG IN</button>
  </div>
</template>

<script>
import axios from "axios";

export default {


  name: "log",
  data() {
    return {
      name: "",
      password: "",
    };
  },

  methods: {
    logIn() {
      axios
          .post("http://localhost:33323/auth/signin", {}, {
            auth:{
              username: this.name,
              password: this.password,
            }
          })
          .then((response) => {
            console.log(response);
          })
          .catch((error) => {
            console.log(error);
          });
    }
  },
}
</script>

<style scoped>

</style>