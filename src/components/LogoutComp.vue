<template>
    <p @click="logout" id="logout">SE DÉCONNECTER</p>

</template>

<script>
import "../assets/style/logout.css";
export default {
    name: "LogoutComp",
    methods: {
        /**
         * Logout the user
         */
        logout() {
            sessionStorage.removeItem("access_token");
            sessionStorage.removeItem("refresh_token");
            this.$router.push('/accueil');
            location.reload();

        },
    },
}
</script>

<style scoped>


</style>