<template>
    <div>
        <defaultHeader/>
        <NuxtPage />
    </div>
    
  </template>

  <script>
    import defaultHeader from '~/components/Header/defaultHeader.vue';
    export default {
        components: {
            defaultHeader
        }
    }
    </script>

