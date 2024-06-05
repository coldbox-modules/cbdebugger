<template>
	<div class="px-4 py-2 sm:px-2">
		{{ title }}
	</div>
	<div class="overflow-y-auto max-h-80">
		<table class="border-separate border-spacing-y-1 table-auto w-full">
			<thead>
				<tr>
					<th
						scope="col"
						class="text-xs font-thin text-left text-gray-400 pl-2"
					>
						Time
					</th>
					<th
						scope="col"
						class="text-xs font-thin text-left text-gray-400 pl-2"
					>
						Query
					</th>
					<th
						scope="col"
						class="text-xs font-thin text-left text-gray-400 pl-2"
					>
						ms
					</th>
				</tr>
			</thead>
			<tbody>
				<template v-for="event in eventsList" :key="event.EVENTID">
					<tr class="bg-slate-900 text-white h-10">
						<td class="p-3 font-thin" nowrap>
							<div>{{ formatTime(event.timestamp) }}</div>
							<div>{{ event.extraInfo.datasource }}</div>
						</td>

						<td
							scope="row"
							class="flex items-center px-4 py-2 font-medium text-gray-900 dark:text-white"
						>
							<highlighted-code
								language="sql"
								:code="event.extraInfo.sql"
							></highlighted-code>
							<div
								class="database-query-bindings"
								v-if="event.extraInfo.extraInfo"
							>
								<pretty-print
									:data="event.extraInfo.extraInfo"
								></pretty-print>
							</div>
						</td>
						<td class="p-3 font-thin" nowrap>
							<span class="p-3 font-thin">
								{{
									eventTypeStore.getLargestTime(
										event.extraInfo.executionTime
									)
								}}</span
							>
						</td>
					</tr>
				</template>
			</tbody>
		</table>
	</div>
</template>
<script setup>
import { ref, defineProps, onMounted } from "vue";
import VueJsonView from "@matpool/vue-json-view";
import { HighCode } from "vue-highlight-code";
import "vue-highlight-code/dist/style.css";
import { useEventTypeStore } from "@/stores/EventTypeStore.js";
import moment from "moment";
import sqlFormatter from "@sqltools/formatter";
import HighlightedCode from "@/components/helpers/HighlightedCode.vue";
import PrettyPrint from "@/components/helpers/PrettyPrint.vue";

const eventTypeStore = useEventTypeStore();
const props = defineProps({
	type: String,
	title: String,
});
const eventsList = ref([]);
onMounted(async () => {
	const list = await eventTypeStore.fetchEvents(props.type);
	console.log(list);
	// add list items to eventsList
	list.forEach((row) => eventsList.value.push(row));
});

const formatTime = (timestamp) => {
	return new Date(timestamp).toLocaleTimeString();
};
const formatDuration = (timeduration) => {
	return moment
		.duration(timeduration / 1000, "milliseconds")
		.humanize("milliseconds");
};

const isValidJSON = (val) => {
	console.log(val, typeof val);
	return typeof val === "object" || typeof val === "array";
};
</script>
<style scoped>
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";
td {
	@apply p-2 text-xs;
}
tr {
	@apply border;
}
.category {
	@apply rounded-sm p-1 text-xs;
}
tr.DEBUG {
	@apply bg-blue-500 bg-opacity-90 border-blue-800;
}
tr.DEBUG .category {
	@apply bg-blue-700;
}
tr.ERROR {
	@apply bg-red-500 bg-opacity-90 border-red-800;
}
tr.ERROR .category {
	@apply bg-red-800;
}
</style>
