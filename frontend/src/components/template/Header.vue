
<template>

  <header class="header">
    <div class="leftSide">
      <img src="~@/assets/9464471.png" alt="">
      <h1 class="title">Ressources Relationnel</h1>
    </div>
    <slot></slot>
  </header>
</template>

<script setup>
</script>


<style scoped>

    *{
      font-family: "Apple SD Gothic Neo", cursive;
    }

    .header{
      width: 100%;
      height: 7rem;
      background-color: white;
      display: flex;
      justify-content: space-between;
      padding: 0 3rem ;
    }

    .title{
      color: #222222;
      padding: 2rem;
      font-weight: bold;
      font-family: "Apple SD Gothic Neo", cursive;
    }

    .leftSide{
      display: flex;
      flex-direction: row;
    }

    img{
      width: 5rem;
      height: 5rem;
      margin-left: 1rem;
      margin-top: 1rem;
    }


</style>