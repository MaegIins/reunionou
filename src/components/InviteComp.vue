<template>
  <div id="inviteComp">

      <h1 @click="this.$router.push('/accueil')">REUNIONOU.APP</h1>

      <div>
          <h2>{{ eventName }}</h2>
          <h2>{{ formatDate(eventDate) }}</h2>

          <p>{{description}}</p>


          <div id="boutons">
              <div>
                  <button @click="">Je viens !</button>
                  <button @click="">Je ne viens pas</button>
              </div>
          </div>

          <MapComp :eventPos="eventPosition"></MapComp>
      </div>













  </div>






</template>

<script>
import MapComp from "@/components/MapComp.vue";
export default {
    name: "InviteComp",
    components: {MapComp},
    data(){
        return {
            idEvent: this.$route.params.id,
            eventName: "",
            eventDate: "",
            eventPosition: [20, 2],
            description: "",
            organizerName: "",
            organizerEmail: "",
            people: [],
            comments: [],

        }
    },
    methods:{
        formatDate(date){
            return date;

        }
    },
}
</script>

<style scoped>
MapComp {
    height: 500px;
    width: 500px;
}

</style>