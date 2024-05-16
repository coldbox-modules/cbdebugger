<template>
<div class="pt-4 bg-white dark:bg-gray-800">
	<label for="table-search" class="sr-only">Search</label>
	<div class="relative mt-1 px-1">
		<div class="absolute inset-y-0 rtl:inset-r-0 start-0 flex items-center ps-3 pointer-events-none">
			<svg class="w-4 h-4 text-gray-500 dark:text-gray-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
				<path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z"/>
			</svg>
		</div>
		<input type="text" id="table-search" class="block py-1 ps-10 w-full text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="Search for items">
	</div>
</div>
<table class="w-100 text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400 text-xs">
	<tbody>

		<template v-if="items">
			<tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
				<th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
					{{title}}
				</th>
			</tr>
				<template v-for="(settingValue,settingKey) in items">
				<tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
					<td scope="row">
						<div class="text-gray-900 whitespace-nowrap dark:text-white">{{settingKey}}</div>
						<div class="mt-1">
							<template v-if="typeof settingValue === 'array' || typeof settingValue === 'object'">
								<VueJsonView theme="chalk" :src="settingValue" collapsed sortKeys />
							</template>

							<template v-else>
								{{settingValue}}
							</template>
						</div>
					</td>
				</tr>
			</template>
		</template>
	</tbody>
</table>
</template>
<script setup>
import VueJsonView from '@matpool/vue-json-view'
import { HighCode } from 'vue-highlight-code';

const props = defineProps({
	items: Object,
	title: String
});

</script>

<style scoped>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

.status_badge {
	@apply inline-flex items-center text-xs font-medium px-2.5 py-0.5 rounded-full
}
.status_indicator{
	@apply w-2 h-2 me-1 rounded-full;
}
.status_active {@apply status_badge  bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300;}
.status_active .indicator {@apply status_indicator bg-green-100 text-green-800;}

.status_inactive {@apply status_badge  bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300;}
.status_inactive .indicator {@apply status_indicator bg-red-100 text-red-800;}
</style>