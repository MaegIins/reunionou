<template>
  <div>
    <h1>SignUp</h1>
    <input v-model="name" placeholder="USERNAME" />
    <input v-model="email" placeholder="EMAIL">
    <input v-model="password" placeholder="PASSWORD" />
    <button v-on:click="signIn">SIGN IN</button>

    <p v-if="showValidationErrors">{{ validationError }}</p>
    <p v-if="showServerError">{{ serverError }}</p>
    <p v-if="showConfirmMessage">{{ confirmMessage }}</p>
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
      showValidationErrors: false,
      validationError: "",
      showServerError: false,
      serverError: "",
      confirmMessage: "",
      showConfirmMessage: false,

    };
  },
  methods: {
    signIn() {
      axios
        .post("http://localhost:3333/auth/signup", {
          name: this.name,
          mail: this.email,
          password: this.password,
        })
        .then((response) => {
          if (response.status === 200 || response.status === 201) {
            this.confirmMessage = "Votre compte a bien été créé.";
            this.showConfirmMessage = true;
          } else {
            this.serverError = "Merci de renseigner tous les champs correctement.";
            this.showServerError = true;
          }
        })
        .catch((error) => {
          if (error.response.status === 422) {
            this.validationError = "Des champs sont manquants ou invalides.";
            this.showValidationErrors = true;
          } else {
            this.serverError = "Merci de renseigner tous les champs correctement.";
            this.showServerError = true;
          }
        });
    },
  },
}
</script>

<style scoped></style>
