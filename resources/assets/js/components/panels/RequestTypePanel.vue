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
						Method
					</th>
					<th
						scope="col"
						class="text-xs font-thin text-left text-gray-400 pl-2"
					>
						Route
					</th>
					<th
						scope="col"
						class="text-xs font-thin text-left text-gray-400 pl-2"
					>
						Count
					</th>
				</tr>
			</thead>
			<tbody>
				<template v-for="event in requestsList" :key="event.EVENTID">
					<tr class="bg-slate-900 text-white h-10">
						<td class="p-3 font-thin" nowrap>
							<div>{{ event.method }}</div>
						</td>

						<td
						scope="row"
						class=" items-center px-4 py-2 font-medium text-gray-900 dark:text-white"
						>
						<div>{{ event.details }}</div>
						<div class="text-xs text-gray-300">{{ event.executionTimeMillis }}ms</div>

						</td>
						<td
						scope="row"
						class=" items-center px-4 py-2 font-medium text-gray-900 dark:text-white"
						>
						<div>{{ event.count }}</div>

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
import { useRequestTypeStore } from "@/stores/RequestTypeStore.js";
import moment from "moment";
import sqlFormatter from "@sqltools/formatter";
import HighlightedCode from "@/components/helpers/HighlightedCode.vue";
import PrettyPrint from "@/components/helpers/PrettyPrint.vue";

const requestTypeStore = useRequestTypeStore();
const props = defineProps({
	type: String,
	title: String,
});
const requestsList = ref([]);
onMounted(async () => {
	const list = await requestTypeStore.fetchRequests(props.type);
	console.log(list);
	// add list items to requestsList
	list.forEach((row) => requestsList.value.push(row));
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
