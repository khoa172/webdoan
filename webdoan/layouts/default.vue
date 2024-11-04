<template>
    <div>
        <defaultHeader/>
        <Nuxt />
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

