<template>
  <div id="comments">
    <h2>Commentaires</h2>
    <div id="listComs">


      <div v-for="comment in comments" :key="comment.id" id="comment">
        <div id="commentHeader">
          <p id="name">{{ comment.id }}</p>
          <p>{{ comment.date }}</p>
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
}
</script>

<style scoped>

</style>