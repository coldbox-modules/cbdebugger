<!-- Tab.vue -->
<template>
	<div class="tab flex flex-col items-center p-2">
		<div class="tab-navigation flex space-x-4">
			<button v-for="tab in tabs" :key="tab.id" @click="selectTab(tab.id)" class="p-1 rounded bg-blue-500 text-white">{{ tab.title }}</button>
		</div>
		<div class="panels">
			<Panel v-for="panel in selectedTab.panels" :key="panel.id" :panel="panel" />
		</div>
	</div>
</template>

<script setup>
import { ref, defineProps } from 'vue'
import Panel from './Panel.vue'

const props = defineProps({
	tabs: Array
})

const selectedTab = ref(props.tabs[0])

const selectTab = (id) => {
	selectedTab.value = props.tabs.find(tab => tab.id === id)
}
</script>

<style scoped>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';
</style>