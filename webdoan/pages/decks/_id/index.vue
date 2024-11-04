<template>
    <h1>your deck route {{ $route.params.id }}</h1>
</template>


<script>
export default  {
    validate(context) {
    return /^[0-9]{9,12}$/.test(context.params.id)
    }
}
</script>
