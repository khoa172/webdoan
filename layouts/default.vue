<template>
    <div>
        <defaultHeader/>
        <NuxtPage /><br>
        <defaultFooter/>
    </div>
  </template>

  <script>
    import defaultHeader from '~/components/Header/defaultHeader.vue';
    import defaultFooter from '~/components/Footer/defaultFooter.vue';
    export default {
        components: {
            defaultHeader,
            defaultFooter
        }
    }
    </script>

