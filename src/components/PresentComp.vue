<template>
  <div id="pplList">
    <h2>Participants</h2>
    <div id="everyPpl">

      <div class="people" id="organizer">
        <p>{{ organizer }} - {{ orgaMail }}</p>
        <i class="bi bi-star-fill"></i>
      </div>
      <div v-for="person in listPpl" :key="person.id" id="pplin">

        <div v-if="person.status === 0" class="people" id="maybe">
          <p>{{ person.name_user }}</p>
          <i class="bi bi-question-circle"></i>
        </div>
        <div v-if="person.status === 1" class="people" id="coming">
          <p>{{ person.name_user }}</p>
          <i class="bi bi-check2"></i>
        </div>
        <div v-if="person.status === 2" class="people" id="notComing">
          <p>{{ person.name_user }}</p>
          <i class="bi bi-x-lg"></i>
        </div>

      </div>
    </div>

    <button><i class="bi bi-plus"></i></button>
  </div>
</template>

<script>
import "./../assets/style/PresentComp.css";
export default {
  name: "PresentComp",
  props: ["listPpl", "organizer", "orgaMail"],
}

</script>

<style scoped></style>