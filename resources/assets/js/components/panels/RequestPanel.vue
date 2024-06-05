<template>
	<div class="grid grid-cols-1 gap-2 lg:grid-cols-3 lg:gap-4">
	  <div class="h-32 rounded-lg bg-gray-200 lg:col-span-2 dark:bg-gray-700">
		<div class="overflow-x-auto">
		  <div class="flex flex-col px-4 py-3 space-y-3 lg:flex-row lg:items-center lg:justify-between lg:space-y-0 lg:space-x-4">
              <div class="flex items-center flex-1 space-x-4">
                  <h5>
                      <span class="text-gray-500 pr-1">Total Timers:</span>
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
			<table class="table-auto w-full text-sm text-left text-gray-500 dark:text-gray-200">
                  <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-200 ">
					<tr class="border-b dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700">
						<th width="120"  	scope="col" class="px-4 py-1">	Type</th>
						<th width="100"  	scope="col" class="px-4 py-1">	Start</th>
						<th width="50" 		scope="col" class="px-4 py-1">	End	</th>
						<th width="50"				scope="col" class="px-4 py-1">Duration</th>
						<th width="50"  	scope="col" class="px-4 py-1">	Count	</th>
					</tr>
				</thead>
				<tbody>
					<template v-for="(eventType, eventTypeName) in requestStore.getSelectedRequest.stats">
						<tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">

							<td  class="px-4 py-1">{{(eventTypeName)}}</td>
							<td  class="px-4 py-1">{{(eventType.first)}}</td>
							<td  class="px-4 py-1">{{(eventType.last)}}</td>
							<td  class="px-4 py-1">{{eventType.duration}}</td>
							<td  class="px-4 py-1">{{eventType.count}}</td>
						</tr>
					</template>
				</tbody>
			</table>
		</div>
			</div>
	  </div>
	  <div class="h-32 rounded-lg bg-gray-800 dark:bg-gray-700">
		<DetailDrawer title="Request Context" :items="eventStore.filteredEvents[0].extraInfo.rc"></DetailDrawer>
		<DetailDrawer title="Private Request Context" :items="eventStore.filteredEvents[0].extraInfo.prc"></DetailDrawer>
		<DetailDrawer title="HTTP Request" :items="eventStore.filteredEvents[0].extraInfo.requestData"></DetailDrawer>
		<DetailDrawer title="HTTP Response" :items="eventStore.filteredEvents[0].extraInfo.response"></DetailDrawer>
	  </div>
	</div>
  </template>
  <script setup>
  import { ref, onMounted } from 'vue'
  import { useEventStore } from "@/stores/EventStore.js";
  import { useRequestStore } from "@/stores/RequestStore.js";
  import DetailDrawer from '@/components/helpers/DetailDrawer.vue'

  import 'vue-highlight-code/dist/style.css'

  const eventStore = useEventStore();
  const requestStore = useRequestStore();
  onMounted(async () => {
	await eventStore.fetchEvents();
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