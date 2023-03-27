<template>
  <div>
    <h3>Commentaires:</h3>
    <ul>
      <li v-for="(comment, index) in comments" :key="index">
        {{ comment.text }}
      </li>
    </ul>
    <form @submit.prevent="addComment">
      <input type="text" v-model="newComment" placeholder="Add a comment...">
      <button type="submit">Add</button>
    </form>
  </div>
</template>

<script>
export default {
  props: ['eventId'],
  data() {
    return {
      comments: [], // add an empty array for comments
      newComment: '',
    }
  },
  methods: {
    addComment() {
      const newComment = {
        text: this.newComment,
        eventId: this.eventId,
      };
      this.comments.push(newComment);
      this.newComment = '';
    },
  }
}
</script>

<style>
/* add your custom styles here */
</style>
