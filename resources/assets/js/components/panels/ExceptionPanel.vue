<template>

<section class="bg-gray-50 dark:bg-gray-900">
      <div class=" bg-white shadow-md dark:bg-red-900">

          <div class="">
              <!-- <table class="table-auto w-full text-sm text-left text-gray-500 dark:text-gray-400">
                  <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                      <tr>
						  <th scope="col" class="px-4 py-3">Time</th>
                          <th scope="col" class="px-4 py-3">Records</th>
                          <th scope="col" class="px-4 py-3">Query</th>
                          <th scope="col" class="px-4 py-3">TS</th>
                      </tr>
                  </thead>
                  <tbody>
					<template v-for="event in eventStore.filteredEvents" :key="event.EVENTID">
                      <tr class="border-b dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700">
						  <td class="w-4 px-4 py-3" nowrap>
							<div>{{formatTime(event.timestamp)}}</div>
							<div>{{event.extraInfo.datasource}}</div>
						</td>
						<td class="w-4 px-4 py-3">{{ event.extraInfo.recordCount }}</td>

                          <td scope="row" class="flex items-center px-4 py-2 font-medium text-gray-900 dark:text-white">
							<highlighted-code language="sql" :code="event.extraInfo.sql"></highlighted-code>
							<div class="database-query-bindings" v-if="event.extraInfo.extraInfo">
									<pretty-print :data="event.extraInfo.extraInfo"></pretty-print>
								</div>
                          </td>

						<td class="w-4 px-4 py-3"> {{eventStore.getLargestTime(event.extraInfo.executionTime)}}</td>
                      </tr>
						</template>

                  </tbody>
              </table> -->
			  <template v-for="event in eventStore.filteredEvents" :key="event.EVENTID">
				<table class="table-auto w-full text-sm text-left text-red-800 dark:text-red-100">
				<tbody>
						<template v-for="(itemValue,itemKey) in event.extraInfo" :key="itemKey">
							<tr class="border-b dark:border-red-600 hover:bg-red-100 dark:hover:bg-red-700">
								<td class="log-date">{{itemKey}}</td>
								<td class="log-date">
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
				</tbody>
			</table>
			</template>

      </div>
  </div>
</section>

</template>
<script setup>
import { ref, defineProps, onMounted } from 'vue'
import VueJsonView from '@matpool/vue-json-view'
import { HighCode } from 'vue-highlight-code';
import 'vue-highlight-code/dist/style.css'
import { useEventStore } from "@/stores/EventStore.js";
import moment from "moment";
import sqlFormatter from '@sqltools/formatter';
import HighlightedCode from '@/components/helpers/HighlightedCode.vue'
import PrettyPrint from '@/components/helpers/PrettyPrint.vue'


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