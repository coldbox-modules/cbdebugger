<!-- Panel.vue -->
<template>
	<div class="p-2 bg-white rounded shadow">
		<h3 class="text-lg font-semibold">{{ panel.title }}</h3>
		<p class="text-gray-600">{{ panel.content }}</p>
	</div>
</template>

<script setup>
import { defineProps } from 'vue'

const props = defineProps({
	panel: Object
})
</script>
<style scoped>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';
</style>