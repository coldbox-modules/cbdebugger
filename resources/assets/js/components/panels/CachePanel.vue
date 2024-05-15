<template>
	<VueJsonView theme="chalk" :src="cacheStore.stats" collapsed sortKeys />
    <div class="bg-gray-800 text-gray-500 rounded shadow-xl py-5 px-5 w-full lg:w-1/2">
        <div class="flex flex-wrap items-end">
            <div class="flex-1">
                <h3 class="text-lg font-semibold leading-tight">Income</h3>
            </div>
            <!-- <div class="relative" @click="chartData.showDropdown=false">
                <button class="text-xs hover:text-gray-300 h-6 focus:outline-none" @click="chartData.showDropdown=!chartData.showDropdown">
                    <span x-text="chartData.options[chartData.selectedOption].label"></span><i class="ml-1 mdi mdi-chevron-down"></i>
                </button>
                <div class="bg-gray-700 shadow-lg rounded text-sm absolute top-auto right-0 min-w-full w-32 z-30 mt-1 -mr-3" x-show="chartData.showDropdown" style="display: none;" x-transition:enter="transition ease duration-300 transform" x-transition:enter-start="opacity-0 translate-y-2" x-transition:enter-end="opacity-100 translate-y-0" x-transition:leave="transition ease duration-300 transform" x-transition:leave-start="opacity-100 translate-y-0" x-transition:leave-end="opacity-0 translate-y-4">
                    <span class="absolute top-0 right-0 w-3 h-3 bg-gray-700 transform rotate-45 -mt-1 mr-3"></span>
                    <div class="bg-gray-700 rounded w-full relative z-10 py-1">
                        <ul class="list-reset text-xs">
                            <template x-for="(item,index) in chartData.options">
                                <li class="px-4 py-2 hover:bg-gray-600 hover:text-white transition-colors duration-100 cursor-pointer" :class="{'text-white':index==chartData.selectedOption}" @click="chartData.selectOption(index);chartData.showDropdown=false">
                                    <span x-text="item.label"></span>
                                </li>
                            </template>
                        </ul>
                    </div>
                </div>
            </div> -->
        </div>
        <!-- <div class="flex flex-wrap items-end mb-5">
            <h4 class="text-2xl lg:text-3xl text-white font-semibold leading-tight inline-block mr-2" x-text="'$'+(chartData.data?chartData.data[chartData.date].total.comma_formatter():0)">0</h4>
            <span class="inline-block" :class="chartData.data&&chartData.data[chartData.date].upDown<0?'text-red-500':'text-green-500'"><span x-text="chartData.data&&chartData.data[chartData.date].upDown<0?'▼':'▲'">0</span> <span x-text="chartData.data?chartData.data[chartData.date].upDown:0">0</span>%</span>
        </div> -->
        <div>
			<TimeSeriesChart ref="chart1"/>
			<TimeSeriesChart ref="chart2"/>
			<TimeSeriesChart ref="chart3"/>
			<TimeSeriesChart ref="chart4"/>
			<TimeSeriesChart ref="chart5"/>
        </div>
</div>

</template>
<script setup>
import { ref, onMounted } from 'vue'
import VueJsonView from '@matpool/vue-json-view'
import { useCacheStore } from "@/stores/CacheStore.js";
import TimeSeriesChart from '../helpers/TimeSeriesChart.vue';

const cacheStore = useCacheStore();

const chart1 = ref(null);
const chart2 = ref(null);
const chart3 = ref(null);
const chart4 = ref(null);
const chart5 = ref(null);

onMounted(async () => {
  setInterval(() => {
    fetchSystemStats();
  }, 1000); // Add data point every second
  await cacheStore.fetchCache();
});

const fetchSystemStats = async function() {
	try {
		const response = await fetch( `${window.location.origin}/cbDebugger/getJVMReport`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
		if (!response.ok) throw new Error('Failed to fetch stats');
		const data = await response.json();

		chart1.value.addDataPoint(data.data.JVM.heapMemory.used);
		chart2.value.addDataPoint(data.data.JVM.nonHeapMemory.used);
		chart3.value.addDataPoint(data.data.JVM.freeMemory);
	} catch (error) {
		console.error('Error fetching stats:', error);
	}
}

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