<template>
  <div>
    <b-navbar toggleable="lg" type="dark" class="custom-navbar">
      <b-navbar-brand>
        <NuxtLink to="/">Home</NuxtLink>
      </b-navbar-brand>
      <b-navbar-brand>
        <NuxtLink to="/about">About</NuxtLink>
      </b-navbar-brand>
      <b-navbar-brand>
        <NuxtLink to="/decks">Decks</NuxtLink>
      </b-navbar-brand>
      <b-navbar-brand>
        <NuxtLink to="/profile">Profile</NuxtLink>
      </b-navbar-brand>
      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav class="ml-auto">
          <b-nav-form>
            <b-form-input size="sm" class="mr-sm-2" placeholder="Search"></b-form-input>
            <b-button size="sm" class="my-2 my-sm-0" type="submit">Search</b-button>
          </b-nav-form>

          <b-nav-item-dropdown right>
            <template #button-content>
              <em>User</em>
            </template>
            <b-dropdown-item>
              <NuxtLink to="/decks">Decks</NuxtLink>
            </b-dropdown-item>
            <b-dropdown-item >
              <NuxtLink to="/login">Login</NuxtLink>
            </b-dropdown-item>
          </b-nav-item-dropdown>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
  </div>
</template>

<style>
.custom-navbar {
  background-color: #070708; /* Chọn màu tùy chỉnh của bạn */
}
</style>