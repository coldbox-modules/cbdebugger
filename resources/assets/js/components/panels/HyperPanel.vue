<template>
	<div class="grid grid-cols-1 gap-2 lg:grid-cols-3 lg:gap-4">
	  <div class="h-32 rounded-lg bg-gray-200 lg:col-span-2 dark:bg-gray-700">
		<div class=" bg-white shadow-md dark:bg-gray-800">
           <div class="flex flex-col px-4 py-3 space-y-3 lg:flex-row lg:items-center lg:justify-between lg:space-y-0 lg:space-x-4">
              <div class="flex items-center flex-1 space-x-4">
                  <h5>
                      <span class="text-gray-500 pr-1">Total Queries:</span>
                      <span class="dark:text-white"> {{ eventStore.totalEventCount}}</span>
                  </h5>
                  <h5>
                      <span class="text-gray-500 pr-1">Total Time:</span>
                      <span class="dark:text-white"> {{ eventStore.totalEventTime }}</span>
                  </h5>
              </div>
              <div class="flex flex-col flex-shrink-0 space-y-3 md:flex-row md:items-center lg:justify-end md:space-y-0 md:space-x-3">
                <label for="table-search" class="sr-only">Search</label>
				<div class="relative">
					<div class="absolute inset-y-0 rtl:inset-r-0 start-0 flex items-center ps-3 pointer-events-none">
						<svg class="w-4 h-4 text-gray-500 dark:text-gray-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
							<path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z"/>
						</svg>
					</div>
					<input type="text" v-model="eventStore.searchFilter" class="block p-2 ps-10 text-sm text-gray-900 border border-gray-300 rounded-lg w-80 bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="Search">
				</div>
				<button type="button" class="flex items-center justify-center flex-shrink-0 px-3 py-2 text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg focus:outline-none hover:bg-gray-100 hover:text-primary-700 focus:z-10 focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700">
                      <svg class="w-4 h-4 mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewbox="0 0 24 24" stroke-width="2" stroke="currentColor" aria-hidden="true">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5" />
                      </svg>
                      Export
                  </button>
              </div>
          </div>
          <div class="">
              <table class="table-auto w-full text-sm text-left text-gray-500 dark:text-gray-400">
                  <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                      <tr>
						  <th scope="col" class="px-4 py-3">Start</th>
                          <th scope="col" class="px-4 py-3">Time</th>
                          <th scope="col" class="px-4 py-3">Method</th>
                          <th scope="col" class="px-4 py-3">URL</th>
                      </tr>
                  </thead>
                  <tbody>
					<template v-for="event in eventStore.filteredEvents" :key="event.EVENTID">
                      <tr @click="eventStore.setSelected(event)" class="border-b dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700">
						  <td class="w-4 px-4 py-3" nowrap>
							<div>{{formatTime(event.timestamp)}}</div>
						</td>
						<td class="w-4 px-4 py-3"> {{eventStore.getLargestTime(event.extraInfo.executionTime)}}</td>
						<td class="w-4 px-4 py-3"> {{event.extraInfo.request.method}}</td>
						<td class="w-4 px-4 py-3">{{ event.details }}</td>

                      </tr>
						</template>

                  </tbody>
              </table>

      </div>
  </div>
	  </div>
	  <div class="h-32 rounded-lg bg-gray-800 dark:bg-gray-700" v-if="eventStore.getSelectedEvent">
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
			  <table class="w-100 text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
				  <tbody>

					  <template v-for="(panelItems, panelName) in detailPanels()" :key="panelName">
						  <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
							  <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
								  {{panelName}}
							  </th>
						  </tr>
						  <template v-for="(itemValue,itemKey) in panelItems" :key="itemKey">
							  <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
								  <td scope="row">
									  <div class="text-gray-900 whitespace-nowrap dark:text-white">{{itemKey}}</div>
									  <div class="mt-1">
										  <template v-if="typeof itemValue === 'array' || typeof itemValue === 'object'">
											  <VueJsonView theme="chalk" :src="itemValue" collapsed sortKeys />
										  </template>

										  <template v-else>
											  {{itemValue}}
										  </template>
									  </div>
								  </td>
							  </tr>
						  </template>
					  </template>

				  </tbody>
			  </table>

	  </div>
	</div>
  </template><script setup>
import { ref, defineProps, onMounted } from 'vue'
import VueJsonView from '@matpool/vue-json-view'
import { HighCode } from 'vue-highlight-code';
import 'vue-highlight-code/dist/style.css'
import { useEventStore } from "@/stores/EventStore.js";
import moment from "moment";


const eventStore = useEventStore();
onMounted(async () => {
  await eventStore.fetchEvents();
});

const formatTime = (timestamp) => {
	return new Date(timestamp).toLocaleTimeString()
}
const formatDuration = (timeduration) => {
	return moment.duration(timeduration/1000,'milliseconds').humanize('milliseconds');
}

const detailPanels = function () {
	if(eventStore.getSelectedEvent){
		return {
			"Request": eventStore.getSelectedEvent.extraInfo.request,
			"Response": eventStore.getSelectedEvent.extraInfo.response
		};
	}
	return {};
}


const isValidJSON = val => {
	 console.log(val, typeof val);
  return typeof val === 'object' || typeof val === 'array'
};

</script>
<style scoped >
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
	@apply bg-blue-500 bg-opacity-90 border-blue-800;
}
tr.DEBUG .category{
	@apply bg-blue-700;
}
tr.ERROR {
	@apply bg-red-500 bg-opacity-90 border-red-800;
}
tr.ERROR .category{
	@apply bg-red-800;
}
</style>