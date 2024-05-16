<template>
	<div class="dark overflow-x-scroll">
		
	<div class="columns-4 dark:bg-gray-900 text-white">
		<div class="h-20 text-center pt-8">Randomshmandum</div>
		<div class="h-20"><Doughnut :data="data" :options="options" /></div>
		<div class="h-20"><Doughnut :data="data" :options="options" /></div>
		<div class="h-20"><Doughnut :data="data" :options="options" /></div>
	</div>

	<div class="dashboard grid grid-cols-2 gap-2 w-full h-full dark:bg-gray-900 bg-gray-50 text-white">
		<div class="p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
		</div>
		<div class="p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">

			<div class="text-2xl">Title</div>

			<div class="columns-3 m-8">
				<div>
					<span class="text-xl">64</span>
					<span class="text-xs font-thin text-left text-gray-400 pl-2">value</span>
				</div>
				<div>
					<span class="text-xl">64</span>
					<span class="text-xs font-thin text-left text-gray-400 pl-2">value</span>
				</div>
				<div>
					<span class="text-xl">64</span>
					<span class="text-xs font-thin text-left text-gray-400 pl-2">value</span>
				</div>
			</div>

			<table class="border-separate border-spacing-y-1.5 table-auto w-full">
				<thead>
					<tr>
						<th class="text-xs font-thin text-left text-gray-400 pl-2">Title1</th>
						<th class="text-xs font-thin text-left text-gray-400 pl-2">Title2</th>
						<th class="text-xs font-thin text-left text-gray-400 pl-2">Title3</th>
						<th class="text-xs font-thin text-left text-gray-400 pl-2">Title4</th>
					</tr>
				</thead>
				<tbody>
					<tr class="bg-slate-900 text-white h-10">
						<td class="p-3 font-thin">data1</td>
						<td class="p-3 font-thin">data2</td>
						<td class="p-3 font-thin">data3</td>
						<td class="p-3 font-thin">data4</td>
					</tr>
					<tr class="bg-slate-900 text-white h-10">
						<td class="p-3 font-thin">data1</td>
						<td class="p-3 font-thin">data2</td>
						<td class="p-3 font-thin">data3</td>
						<td class="p-3 font-thin">data4</td>
					</tr>
					<tr class="bg-slate-900 text-white h-10">
						<td class="p-3 font-thin">data1</td>
						<td class="p-3 font-thin">data2</td>
						<td class="p-3 font-thin">data3</td>
						<td class="p-3 font-thin">data4</td>
					</tr>
				</tbody>
			</table>

		</div>
		<div class="p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
		</div>
		<div class="p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">

			<TimerPanel />

		</div>
		<div class=" p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
			<div class="relative overflow-x-auto shadow-md sm:rounded-lg">
				<table class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
					<thead class="text-xs text-gray-700 uppercase bg-gray-200 dark:bg-gray-700 dark:text-gray-400">
						<tr>
							<th scope="col" class="px-6 py-3">
								Product name
							</th>
							<th scope="col" class="px-6 py-3">
								Color
							</th>
							<th scope="col" class="px-6 py-3">
								Category
							</th>
							<th scope="col" class="px-6 py-3">
								Price
							</th>
							<th scope="col" class="px-6 py-3">
								Action
							</th>
						</tr>
					</thead>
					<tbody>
						<tr
							class="odd:bg-white odd:dark:bg-gray-900 even:bg-gray-100 even:dark:bg-gray-800 border-b dark:border-gray-700">
							<th scope="row"
								class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
								Apple MacBook Pro 17"
							</th>
							<td class="px-6 py-4">
								Silver
							</td>
							<td class="px-6 py-4">
								Laptop
							</td>
							<td class="px-6 py-4">
								$2999
							</td>
							<td class="px-6 py-4">
								<a href="#"
									class="font-medium text-blue-600 dark:text-blue-500 hover:underline">Edit</a>
							</td>
						</tr>

					</tbody>
				</table>
			</div>

		</div>

	</div>
	</div>
</template>

<script setup>
	import { ref, onMounted } from 'vue'
	import TimerPanel from './panels/TimerPanel.vue'

	import QueryPanel from './panels/QueryPanel.vue';
	import { useEventStore } from "@/stores/EventStore.js";
	const eventStore = useEventStore();

	import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js'
	import { Doughnut } from 'vue-chartjs'

	ChartJS.register(ArcElement, Tooltip, Legend)

	onMounted(async () => {
	eventStore.setTranactionID('ad05e3ee-6b1a-4c85-98c8-70ee4689870a');
	eventStore.setEventTypes(['timer']);

	});

	const data = {
  		datasets: [{
			backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
			data: [40, 50, 80, 20]
		}]
	}

	const options = {
		responsive: true,
		maintainAspectRatio: false
	}

</script>

<style scoped>
	@import 'tailwindcss/base';
	@import 'tailwindcss/components';
	@import 'tailwindcss/utilities';

	.dashboard {
		font-family: sans-serif;
	}
</style>