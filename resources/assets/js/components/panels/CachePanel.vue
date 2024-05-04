<template>
	<VueJsonView theme="chalk" :src="cacheStore.stats" collapsed sortKeys />
</template>
<script setup>
import { ref, onMounted } from 'vue'
import VueJsonView from '@matpool/vue-json-view'
import { HighCode } from 'vue-highlight-code';
import { useCacheStore } from "@/stores/CacheStore.js";

import 'vue-highlight-code/dist/style.css'

const cacheStore = useCacheStore();
onMounted(async () => {
  await cacheStore.fetchCache();
});

const formatTime = (timestamp) => {
	return new Date(timestamp).toLocaleTimeString()
}


const isValidJSON = val => {
	 console.log(val, typeof val);
  return typeof val === 'object' || typeof val === 'array'
};

</script>
<style scoped>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';
td {
	@apply p-2 text-xs;
}
tr{
	@apply border;
}
.category{
	@apply rounded-sm p-1 text-xs;
}
tr.DEBUG {
	@apply bg-blue-900 bg-opacity-90 border-blue-800;
}
tr.DEBUG .category{
	@apply bg-blue-700;
}
tr.ERROR {
	@apply bg-red-900 bg-opacity-90 border-red-800;
}
tr.ERROR .category{
	@apply bg-red-800;
}
</style>