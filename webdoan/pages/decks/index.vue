<template>
  <div>
    <h1>nhấn number cần vào</h1>
    <input v-model="deckID" type="text"  placeholder="ghi deck cần vào">
    <button @click="showDECk">go to deck</button>
  </div>
  
  </template>
  
  <script>
  export default {
    data() {
      return {
        deckID: '1'
      }
    },
    methods: {
      showDECk() {
        this.$router.push(`/decks/${this.deckID}`)
      }
    }
  }
  </script>
  