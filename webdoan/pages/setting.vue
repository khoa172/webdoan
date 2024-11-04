<template>
    <div class="page">
      <div class="nav">
        <ul>
          <li>
            <NuxtLink to="/setting">General</NuxtLink>
          </li>
          <li>
            <NuxtLink to="/setting/decks">Deck</NuxtLink>
          </li>
          <li>
            <NuxtLink to="/setting/profile">Profile</NuxtLink>
          </li>
        </ul>
        <ul>
          <nuxt-child/>
        </ul>
      </div>

    </div>
  </template>
  
  <style lang="scss">
    .pages{
        display:flex;
        .main {
          margin-left: 3rem;
        }
    }
  </style>