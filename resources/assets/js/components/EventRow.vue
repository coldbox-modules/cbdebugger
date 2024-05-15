<!-- Tab.vue -->
<template>
	<div class="tab flex p-2 border-bottom">
		<div class="flex-auto flex-col body">
			{{ event.details }}
			<div class="small">{{ formatTime(event.timestamp) }}</div>
		</div>
		<div class="">
			<a :href="'vscode://' + event.caller">File</a>
		</div>

	</div>
</template>

<script setup>
import { ref, defineProps } from 'vue'
import VueJsonView from '@matpool/vue-json-view'

const props = defineProps({
	event: Object
})

const formatTime = (timestamp) => {
	return new Date(timestamp).toLocaleTimeString()
}
</script>

<style scoped>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';
</style>