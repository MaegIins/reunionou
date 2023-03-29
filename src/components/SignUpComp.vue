<template>
  <div>
    <h1>SignIn</h1>
    <input v-model="name" placeholder="USERNAME"/>
    <input v-model="email">
    <input v-model="password" placeholder="PASSWORD"/>
    <button v-on:click="signIn">SIGN IN</button>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "SignUpComp",
  data() {
    return {
      name: "",
      email: "",
      password: "",
    };
  },
  methods: {
    signIn() {
      axios
        .post("http://localhost:33323/auth/signup", {
          name: this.name,
          email: this.email,
          password: this.password,
        })
        .then((response) => {
          console.log(response);
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
}
</script>

<style scoped>

</style>