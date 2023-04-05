<template>


  <div id="signup">
    <router-link to="/accueil">Retour à l'accueil</router-link>
    <h2>S'inscrire</h2>
    <input ref="name" v-model="name" placeholder="Nom d'utilisateur" v-on:keydown.enter="setFocusOnMail" />
    <input ref="mail" v-model="email" placeholder="Adresse mail" v-on:keydown.enter="setFocusOnPwd">
    <input ref="pwd" type="password" v-model="password" placeholder="Mot de passe" v-on:keydown.enter="setFocusOnCpwd"/>
    <input ref="cpwd" type="password" v-model="confirmPassword" placeholder="Confirmer le mot de passe" @keydown.enter="signIn"/>
    <button v-on:click="signIn">S'inscrire!</button>
    <router-link to="/login">Déjà un compte?</router-link>

    <div id="error">
      <p v-if="showValidationErrors">{{ validationError }}</p>
      <p v-if="showServerError">{{ serverError }}</p>
      <p v-if="showConfirmMessage">{{ confirmMessage }}</p>
    </div>


  </div>
</template>

<script>
import api from "../api";
import "../assets/style/signUp.css"
export default {
  name: "SignUpComp",
  mounted() {
    this.setFocusOnName();
  },
  data() {
    return {
      name: "",
      email: "",
      password: "",
      confirmPassword: "",
      showValidationErrors: false,
      validationError: "",
      showServerError: false,
      serverError: "",
      confirmMessage: "",
      showConfirmMessage: false,

    };
  },
  methods: {
      /**
       * Set focus on name input
       */
    setFocusOnName() {
      this.$refs.name.focus();
    },
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
       * Set focus on confirm password input
       */
    setFocusOnCpwd() {
      this.$refs.cpwd.focus();
    },
      /**
       * Sign in
       */
    signIn() {


      if (this.password !== this.confirmPassword) {
        this.validationError = "Les mots de passe ne correspondent pas.";
        this.showValidationErrors = true;
        return;
      }

      api
        .post("auth/signup", {
          name: this.name,
          mail: this.email,
          password: this.password,
        })
        .then((response) => {
          if (response.status === 200 || response.status === 201) {
            this.confirmMessage = "Votre compte a bien été créé.";
            this.showConfirmMessage = true;
            this.$router.push("/login");
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
