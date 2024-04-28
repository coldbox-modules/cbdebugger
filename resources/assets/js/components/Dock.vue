<!-- Dock.vue -->
<template>
	<div class="dock flex flex-col w-full h-1/2 bottom-0 fixed border border-gray-600 bg-gray-800 text-white" :class="{ 'is-open': isOpen, 'h-full': isOpen }">
	  <div class="title-bar flex justify-between items-center p-1 bg-gray-900">
		<span class="title text-lg">{{ title }}</span>
		<div class="controls flex space-x-2">
		  <button @click="toggleDock" class="p-1 rounded">
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="h-6 w-6 text-blue-500 hover:text-blue-700">
			  <path v-if="isOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
			  <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
			</svg>
		  </button>
		  <button class="p-1 rounded">
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="h-6 w-6 text-blue-500 hover:text-blue-700">
			  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
			</svg>
		  </button>
		  <div class="relative inline-block text-left">
			<button @click="toggleDropdown" class="inline-flex justify-center w-full rounded-md border border-gray-300 shadow-sm px-2 py-1 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
			  Options
			  <svg class="-mr-1 ml-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
				<path fill-rule="evenodd" d="M10 12a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd" />
				<path fill-rule="evenodd" d="M10 2a8 8 0 100 16 8 8 0 000-16zM2 10a8 8 0 1116 0 8 8 0 01-16 0z" clip-rule="evenodd" />
			  </svg>
			</button>
			<div v-show="isDropdownOpen" class="origin-top-right absolute right-0 mt-2 w-56 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5">
			  <div class="py-1" role="menu" aria-orientation="vertical" aria-labelledby="options-menu">
				<a href="#" class="block px-2 py-1 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900" role="menuitem">Option 1</a>
				<a href="#" class="block px-2 py-1 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900" role="menuitem">Option 2</a>
			  </div>
			</div>
		  </div>
		</div>
	  </div>
	  <div class="tabs flex space-x-2 overflow-auto">
		<nav class="bg-gray-50 dark:bg-gray-700">
			<div class="max-w-screen-xl px-2 py-1 mx-auto">
				<div class="flex items-center">
					<ul class="flex flex-row font-medium mt-0 space-x-8 rtl:space-x-reverse text-sm">
						<li v-for="tab in tabs" :key="tab.id">
							<a href="#" class="text-gray-900 dark:text-white hover:underline" aria-current="page">{{tab.title}}</a>
						</li>
					</ul>
				</div>
			</div>
		</nav>
	  </div>
	</div>
  </template>

<script setup>
import { ref } from 'vue'
import Tab from './Tab.vue'

const isOpen = ref(true)
const title = ref('Dock Title')
const tabs = ref([{
	id: 1,
	title: 'Tab 1',
	panels: [{
		id: 1,
		title: 'Panel 1',
		content: 'Panel 1 Content'
	}, {
		id: 2,
		title: 'Panel 2',
		content: 'Panel 2 Content'
	}]
}, {
	id: 2,
	title: 'Tab 2',
	panels: [{
		id: 1,
		title: 'Panel 1',
		content: 'Panel 1 Content'
	}, {
		id: 2,
		title: 'Panel 2',
		content: 'Panel 2 Content'
	}]
}, {
	id: 3,
	title: 'Tab 3',
	panels: [{
		id: 1,
		title: 'Panel 1',
		content: 'Panel 1 Content'
	}, {
		id: 2,
		title: 'Panel 2',
		content: 'Panel 2 Content'
	}]
}])
const isDropdownOpen = ref(false)

const toggleDock = () => {
  isOpen.value = !isOpen.value
}

const toggleDropdown = () => {
  isDropdownOpen.value = !isDropdownOpen.value
}
</script>
<style scoped>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';
</style>