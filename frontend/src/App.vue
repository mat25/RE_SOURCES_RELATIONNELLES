<template>
  <n-config-provider :theme="null">
    <n-message-provider>
      <Header>
        <NavigationBar></NavigationBar>
      </Header>
      <main>
        <RouterView />
      </main>
      <Footer />
    </n-message-provider>
  </n-config-provider>
</template>

<script setup>
import { CashOutline as CashIcon } from '@vicons/ionicons5';
import Header from "@/components/template/Header.vue";
import NavigationBar from "@/components/organisms/NavigationBar.vue";
import Footer from "@/components/template/Footer.vue";
import { NConfigProvider, NMessageProvider } from 'naive-ui';
</script>

<style scoped>
main {
  width: 100%;
  min-height: 100vh; 
  height: auto;
  background-color: rgba(13, 52, 158, 0.15);
}

*{
  color: black;
}
</style>