<template>
	<!--
  This example requires updating your template:

  ```
  <html class="h-full bg-gray-100">
  <body class="h-full">
  ```
-->
<div class="min-h-full dark">
  <div class="bg-gray-800">
    <nav class="bg-gray-800">
      <div class="mx-auto max-w-7xl sm:px-6 lg:px-8">
        <div class="border-b border-gray-700">
          <div class="flex h-16 items-center justify-between px-4 sm:px-0">
            <div class="flex items-center">
              <div class="flex-shrink-0">
				<img src="/includes/images/CBDebugger-logo.svg" class="h-8 w-8" alt="CB Debugger" />

              </div>
              <div class="hidden md:block">
                <div class="ml-10 flex items-baseline space-x-4">
                  <!-- Current: "bg-gray-900 text-white", Default: "text-gray-300 hover:bg-gray-700 hover:text-white" -->
                  <a href="#" class="bg-gray-900 text-white rounded-md px-3 py-2 text-sm font-medium" aria-current="page">Dashboard</a>
                  <a href="#" class="text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium">Modules</a>
                  <a href="#" class="text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium">Cache</a>
                  <a href="#" class="text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium">Scheduled Tasks</a>
                </div>
              </div>
            </div>
            <div class="hidden md:block">
              <div class="ml-4 flex items-center md:ml-6">
                <button type="button" class="relative rounded-full bg-gray-800 p-1 text-gray-400 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800">
                  <span class="absolute -inset-1.5"></span>
                  <span class="sr-only">View notifications</span>
                  <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
                  </svg>
                </button>

                <!-- Profile dropdown -->

              </div>
            </div>
            <div class="-mr-2 flex md:hidden">
              <!-- Mobile menu button -->
              <button type="button" class="relative inline-flex items-center justify-center rounded-md bg-gray-800 p-2 text-gray-400 hover:bg-gray-700 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800" aria-controls="mobile-menu" aria-expanded="false">
                <span class="absolute -inset-0.5"></span>
                <span class="sr-only">Open main menu</span>
                <!-- Menu open: "hidden", Menu closed: "block" -->
                <svg class="block h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
                </svg>
                <!-- Menu open: "block", Menu closed: "hidden" -->
                <svg class="hidden h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Mobile menu, show/hide based on menu state. -->
      <div class="border-b border-gray-700 md:hidden" id="mobile-menu">
        <div class="space-y-1 px-2 py-3 sm:px-3">
          <!-- Current: "bg-gray-900 text-white", Default: "text-gray-300 hover:bg-gray-700 hover:text-white" -->
          <a href="#" class="bg-gray-900 text-white block rounded-md px-3 py-2 text-base font-medium" aria-current="page">Dashboard</a>
          <a href="#" class="text-gray-300 hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium">Team</a>
          <a href="#" class="text-gray-300 hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium">Projects</a>
          <a href="#" class="text-gray-300 hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium">Calendar</a>
          <a href="#" class="text-gray-300 hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium">Reports</a>
        </div>
        <div class="border-t border-gray-700 pb-3 pt-4">
          <div class="flex items-center px-5">
            <div class="flex-shrink-0">
              <img class="h-10 w-10 rounded-full" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
            </div>
            <div class="ml-3">
              <div class="text-base font-medium leading-none text-white">Tom Cook</div>
              <div class="text-sm font-medium leading-none text-gray-400">tom@example.com</div>
            </div>
            <button type="button" class="relative ml-auto flex-shrink-0 rounded-full bg-gray-800 p-1 text-gray-400 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800">
              <span class="absolute -inset-1.5"></span>
              <span class="sr-only">View notifications</span>
              <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
              </svg>
            </button>
          </div>
          <div class="mt-3 space-y-1 px-2">
            <a href="#" class="block rounded-md px-3 py-2 text-base font-medium text-gray-400 hover:bg-gray-700 hover:text-white">Your Profile</a>
            <a href="#" class="block rounded-md px-3 py-2 text-base font-medium text-gray-400 hover:bg-gray-700 hover:text-white">Settings</a>
            <a href="#" class="block rounded-md px-3 py-2 text-base font-medium text-gray-400 hover:bg-gray-700 hover:text-white">Sign out</a>
          </div>
        </div>
      </div>
    </nav>
	<div class="flex items-center justify-between p-6">
            <div class="flex-1 space-y-8">
              <div class="space-y-8 sm:flex sm:items-center sm:justify-between sm:space-y-0 xl:block xl:space-y-8">
                <!-- Profile -->
                <div class="flex items-center space-x-3">

                  <div class="space-y-1">
                    <div class="text-3xl font-medium text-gray-100">Dashboard</div>
					<div class="flex flex-col space-y-6 sm:flex-row sm:space-x-8 sm:space-y-0 xl:flex-col xl:space-x-0 xl:space-y-6">
                <div class="flex items-center space-x-2">
                  <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M16.403 12.652a3 3 0 000-5.304 3 3 0 00-3.75-3.751 3 3 0 00-5.305 0 3 3 0 00-3.751 3.75 3 3 0 000 5.305 3 3 0 003.75 3.751 3 3 0 005.305 0 3 3 0 003.751-3.75zm-2.546-4.46a.75.75 0 00-1.214-.883l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
                  </svg>
                  <span class="text-sm font-medium text-gray-500">Clear All Profilers</span>
                </div>
                <!-- <div class="flex items-center space-x-2">
                  <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path d="M5.127 3.502L5.25 3.5h9.5c.041 0 .082 0 .123.002A2.251 2.251 0 0012.75 2h-5.5a2.25 2.25 0 00-2.123 1.502zM1 10.25A2.25 2.25 0 013.25 8h13.5A2.25 2.25 0 0119 10.25v5.5A2.25 2.25 0 0116.75 18H3.25A2.25 2.25 0 011 15.75v-5.5zM3.25 6.5c-.04 0-.082 0-.123.002A2.25 2.25 0 015.25 5h9.5c.98 0 1.814.627 2.123 1.502a3.819 3.819 0 00-.123-.002H3.25z" />
                  </svg>
                  <span class="text-sm font-medium text-gray-500">8 Projects</span>
                </div> -->
              </div>
                  </div>
                </div>
                <!-- Action buttons -->
                <div class="flex flex-col sm:flex-row xl:flex-col space-x-3" >
					<div>
						<dt class="truncate text-xs font-medium text-gray-500">CPU</dt>
      					<dd class="mt-1 text-2xl font-semibold tracking-tight text-gray-100">58.16%</dd>
					</div>
					<TimeSeriesChart ref="chart1"/>
					<div>
						<dt class="truncate text-xs font-medium text-gray-500">Memory</dt>
      					<dd class="mt-1 text-2xl font-semibold tracking-tight text-gray-100">6GB</dd>
					</div>
					<TimeSeriesChart ref="chart2"/>
				</div>
              </div>
              <!-- Meta info -->

            </div>
            </div>
			<div class="bg-gray-900">
  <div class="mx-auto max-w-7xl">
    <div class="grid grid-cols-1 gap-px bg-white/5 sm:grid-cols-2 lg:grid-cols-4">
      <div class="bg-gray-900 px-4 py-6 sm:px-6 lg:px-8">
        <p class="text-sm font-medium leading-6 text-gray-400">Exceptions</p>
        <p class="mt-2 flex items-baseline gap-x-2">
          <span class="text-4xl font-semibold tracking-tight text-white">5</span>
        </p>
      </div>
      <div class="bg-gray-900 px-4 py-6 sm:px-6 lg:px-8">
        <p class="text-sm font-medium leading-6 text-gray-400">Average Load Time</p>
        <p class="mt-2 flex items-baseline gap-x-2">
          <span class="text-4xl font-semibold tracking-tight text-white">3.65</span>
          <span class="text-sm text-gray-400">mins</span>
        </p>
      </div>
      <div class="bg-gray-900 px-4 py-6 sm:px-6 lg:px-8">
        <p class="text-sm font-medium leading-6 text-gray-400">404 Page Hits</p>
        <p class="mt-2 flex items-baseline gap-x-2">
          <span class="text-4xl font-semibold tracking-tight text-white">3</span>
        </p>
      </div>
      <div class="bg-gray-900 px-4 py-6 sm:px-6 lg:px-8">
        <p class="text-sm font-medium leading-6 text-gray-400">Cache Hit Ratio</p>
        <p class="mt-2 flex items-baseline gap-x-2">
          <span class="text-4xl font-semibold tracking-tight text-white">98.5%</span>
        </p>
      </div>
    </div>
  </div>
</div>

  </div>

	<div class="dashboard grid grid-cols-2 gap-2 w-full dark:bg-gray-900 bg-gray-50 text-white">
		<!-- <div class="p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
		</div>
		<div class="p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">

			<div class="text-2">Cache Stats</div>

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

			<table class="border-separate border-spacing-y-1 table-auto w-full">
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

		</div> -->
		<div class="p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
			<RequestTypePanel type="500" title="Exceptions" />
		</div>
		<div class="p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
			<RequestTypePanel type="200" title="Slow Routes" />
		</div>
		<div class="p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
			<SlowQueryPanel type="cfquery" title="Slow Queries" />
		</div>
		<div class=" p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
			<SlowQueryPanel type="qb" title="Slow Quick/QB" />
		</div>
		<div class=" p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
			<SlowQueryPanel type="cborm" title="Slow CBORM" />
		</div>

	</div>
	</div>
</template>

<script setup>
	import { ref, onMounted } from 'vue'

	import SlowQueryPanel from './panels/SlowQueryPanel.vue';
	import RequestTypePanel from './panels/RequestTypePanel.vue';
	import TimeSeriesChart from './helpers/TimeSeriesChart.vue';


	const chart1 = ref(null);
	const chart2 = ref(null);

	onMounted(async () => {
	setInterval(() => {
		fetchSystemStats();
	}, 10000); // Add data point every second
	});

	const fetchSystemStats = async function() {
		try {
			const response = await fetch( `${window.location.origin}/cbDebugger/getJVMReport`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
			if (!response.ok) throw new Error('Failed to fetch stats');
			const data = await response.json();

			if(chart1) chart1.value.addDataPoint(data.data.JVM.heapMemory.used/1024/1024/1024);
			if(chart2) chart2.value.addDataPoint(data.data.JVM.nonHeapMemory.used/1024/1024/1024);
		} catch (error) {
			console.error('Error fetching stats:', error);
		}
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