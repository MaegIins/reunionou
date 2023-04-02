<template>
  <div id="comments">
    <h2>Commentaires</h2>
    <div id="listComs">


      <div v-for="comment in comments" :key="comment.id" id="comment">
        <div id="commentHeader">
          <p id="name">{{ comment.id }}</p>
          <p>{{ formatDate(comment.date) }}</p>
        </div>
        <div id="commentBody">
          <p>{{ comment.text }}</p>
        </div>
      </div>
    </div>
    <div id="commentForm">

      <textarea placeholder="Ajouter un commentaire..."></textarea>
      <button><i class="bi bi-send"></i></button>

    </div>
  </div>
</template>

<script>
import "./../assets/style/CommentComp.css";

export default {
  name: "CommentsComp",
  props: ["comments"],
  methods: {
    formatDate(dateString) {
      const date = new Date(dateString);
      const day = date.getDate().toString().padStart(2, "0");
      const month = (date.getMonth() + 1).toString().padStart(2, "0");
      const year = date.getFullYear();
      const hours = date.getHours().toString().padStart(2, "0");
      const minutes = date.getMinutes().toString().padStart(2, "0");
      const seconds = date.getSeconds().toString().padStart(2, "0");

      return `${day}/${month}/${year} ${hours}:${minutes}:${seconds}`;
    },
  },
}
</script>

<style scoped></style>