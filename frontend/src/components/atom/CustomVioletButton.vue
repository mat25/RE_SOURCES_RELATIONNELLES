<template>
    <button
      class="custom-violet-button"
      :class="{ 'active': isActive }"
      @click="handleClick"
    >
      <slot></slot>
      <span v-if="label">{{ label }}</span>
    </button>
  </template>
  
  <script setup>
  import { ref, computed } from 'vue';
  
  const props = defineProps({
    label: {
      type: String,
      default: '',
    },
    value: {
      type: [String, Number, Boolean, Object],
      default: null,
    },
    modelValue: {
      type: [String, Number, Boolean, Array, Object],
      default: null,
    },
  });
  
  const emit = defineEmits(['update:modelValue', 'click']);
  
  const isActive = computed(() => {
    if (Array.isArray(props.modelValue)) {
      return props.modelValue.includes(props.value);
    }
    return props.modelValue === props.value;
  });
  
  const handleClick = () => {
    emit('click', props.value);
    if (props.modelValue !== null) {
      if (Array.isArray(props.modelValue)) {
        const index = props.modelValue.indexOf(props.value);
        if (index !== -1) {
          emit('update:modelValue', props.modelValue.filter(v => v !== props.value));
        } else {
          emit('update:modelValue', [...props.modelValue, props.value]);
        }
      } else {
        emit('update:modelValue', props.value);
      }
    }
  };
  </script>
  
  <style scoped>
  .custom-violet-button {
    background-color: #6542b1;
    color: white;
    border: 1px solid #6542b1;
    border-radius: 6px;
    padding: 8px 16px;
    font-size: 0.9rem;
    cursor: pointer;
    transition: background-color 0.2s ease, border-color 0.2s ease;
    margin-right: 8px;
  }
  
  .custom-violet-button:hover {
    background-color: #553899;
    border-color: #553899;
  }
  
  .custom-violet-button:focus {
    outline: none;
    box-shadow: 0 0 0 2px rgba(101, 66, 177, 0.5);
  }
  
  .custom-violet-button.active {
    background-color: #553899;
    border-color: #553899;
    font-weight: bold;
  }
  </style>