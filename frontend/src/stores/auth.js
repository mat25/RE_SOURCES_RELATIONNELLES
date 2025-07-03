// src/stores/auth.js

import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useAuthStore = defineStore('auth', () => {
  const tokenKey = 'jwt_token' // ⬅️ Doit correspondre à ce que tu utilises ailleurs
  const token = ref(localStorage.getItem(tokenKey))
  const user = ref(null)

  const isAuthenticated = computed(() => !!token.value)
  const userRole = computed(() => user.value?.role || null)

  function setToken(value) {
    token.value = value
    if (value) {
      localStorage.setItem(tokenKey, value)
    } else {
      localStorage.removeItem(tokenKey)
    }
  }

  function logout() {
    setToken(null)
    user.value = null
  }

  async function fetchUser() {
    if (!token.value) return
    try {
      const response = await fetch('/api/users/me', {
        headers: {
          Authorization: `Bearer ${token.value}`,
        },
      })
      if (!response.ok) throw new Error()
      user.value = await response.json()
    } catch (e) {
      logout()
    }
  }

  function initializeAuth() {
    const savedToken = localStorage.getItem(tokenKey)
    if (savedToken) {
      setToken(savedToken)
    }
  }

  return {
    token,
    user,
    isAuthenticated,
    userRole,
    setToken,
    logout,
    fetchUser,
    initializeAuth,
  }
})
