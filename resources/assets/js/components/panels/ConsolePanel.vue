<template>
	<div class="details-table">
		<div class="table-header">
			<div class="header-title">
				<div class="ui-icon">
					<!-- <svg
						xmlns="http://www.w3.org/2000/svg"
						viewBox="0 0 24 24"
						fill="none"
						stroke="currentColor"
						stroke-width="2"
						stroke-linecap="round"
						stroke-linejoin="round"
						class="feather feather-edit-2"
					>
						<path
							d="M17 3a2.828 2.828 0 114 4L7.5 20.5 2 22l1.5-5.5L17 3z"
						></path>
					</svg> -->
				</div>
				Messages
				<!---->
			</div>
			<div class="header-group">
				<div class="header-search">
					<input type="search" placeholder="Search..." />
					<div class="ui-icon">
						<!-- <svg
							xmlns="http://www.w3.org/2000/svg"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							class="feather feather-search"
						>
							<circle cx="11" cy="11" r="8"></circle>
							<path d="M21 21l-4.35-4.35"></path>
						</svg> -->
					</div>
				</div>
			</div>
		</div>
		<div class="table-content">
			<table class="table-auto w-full">
				<thead>
					<tr>
						<th width="100">
							Time
							<div class="ui-icon" style="display: none">
								<svg
									xmlns="http://www.w3.org/2000/svg"
									viewBox="0 0 24 24"
									fill="none"
									stroke="currentColor"
									stroke-width="2"
									stroke-linecap="round"
									stroke-linejoin="round"
									class="feather feather-chevron-up"
								>
									<path d="M18 15l-6-6-6 6"></path>
								</svg>
							</div>
						</th>
						<th width="80">
							Level
							<div class="ui-icon" style="display: none">
								<svg
									xmlns="http://www.w3.org/2000/svg"
									viewBox="0 0 24 24"
									fill="none"
									stroke="currentColor"
									stroke-width="2"
									stroke-linecap="round"
									stroke-linejoin="round"
									class="feather feather-chevron-up"
								>
									<path d="M18 15l-6-6-6 6"></path>
								</svg>
							</div>
						</th>
						<th>
							Message
							<div class="ui-icon" style="display: none">
								<svg
									xmlns="http://www.w3.org/2000/svg"
									viewBox="0 0 24 24"
									fill="none"
									stroke="currentColor"
									stroke-width="2"
									stroke-linecap="round"
									stroke-linejoin="round"
									class="feather feather-chevron-up"
								>
									<path d="M18 15l-6-6-6 6"></path>
								</svg>
							</div>
						</th>
					</tr>
				</thead>
				<tbody>
					<template v-for="event in eventStore.filteredEvents" :key="event.EVENTID">
					<tr class="log-row" :class="event.extraInfo.severity">
						<td class="log-date">{{formatTime(event.timestamp)}}</td>
						<td class="log-level"><span class="category">{{event.extraInfo.severity}}</span></td>
						<td>
							<div class="log-message">
								<div class="log-message-content" v-if="event.extraInfo.message != ''">
									<template v-if="isValidJSON(event.extraInfo.extraInfo)">
										{{event.extraInfo.message}}
										<VueJsonView theme="chalk" :src="event.extraInfo.extraInfo" collapsed sortKeys />
									</template>
									<template v-if="!isValidJSON(event.extraInfo.extraInfo)">
										{{event.extraInfo.message + '\n' + event.extraInfo.extraInfo}}
									</template>
								</div>
								<div class="log-message-category">
									{{event.extraInfo.category}}
								</div>
							</div>
						</td>
					</tr>
					</template>
				</tbody>
			</table>
		</div>
	</div>
</template>
<script setup>
import { ref, defineProps, onMounted } from 'vue'
import VueJsonView from '@matpool/vue-json-view'
import { HighCode } from 'vue-highlight-code';
import 'vue-highlight-code/dist/style.css'
import { useEventStore } from "@/stores/EventStore.js";

const eventStore = useEventStore();
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