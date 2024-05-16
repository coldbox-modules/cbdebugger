<!-- Dock.vue -->
<template>
	 <div style="z-index: 100000; " class="dark dock flex flex-col w-full bottom-0 fixed border border-gray-600 bg-gray-800 text-white" :class="{ 'is-open': isOpen, 'h-1/2-screen max-h-1/2-screen': isOpen }">
	  <div class="title-bar flex justify-between items-center p-1 bg-gray-900">
		<img src="/includes/images/CBDebugger-logo.svg" class="h-6 w-6" alt="CB Debugger" />

		<template v-if="requestStore.getSelectedRequest">
			<span class="title text-sm">{{ requestStore.getSelectedRequest.details }}</span>
		</template>
		<template v-if="!requestStore.getSelectedRequest">
			<span class="title text-sm">{{ title }}</span>
		</template>


		<div class="controls flex space-x-2">
		  <button @click="toggleDock" class="p-1 rounded">
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="h-4 w-4 text-blue-500 hover:text-blue-700">
			  <path v-if="isOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
			  <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
			</svg>
		  </button>
		  <!-- <button class="p-1 rounded">
			<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="h-6 w-6 text-blue-500 hover:text-blue-700">
			  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
			</svg>
		  </button>
		  <div class="relative inline-block text-left">
			<button @click="toggleDropdown" class="inline-flex justify-center w-full rounded-md border border-gray-300 shadow-sm px-2 py-1 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
			  Options
			  <svg class="-mr-1 ml-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
				<path fill-rule="evenodd" d="M10 12a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd" />
				<path fill-rule="evenodd" d="M10 2a8 8 0 100 16 8 8 0 000-16zM2 10a8 8 0 1116 0 8 8 0 01-16 0z" clip-rule="evenodd" />
			  </svg>
			</button>
			<div v-show="isDropdownOpen" class="origin-top-right absolute right-0 mt-2 w-56 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5">
			  <div class="py-1" role="menu" aria-orientation="vertical" aria-labelledby="options-menu">
				<a href="#" class="block px-2 py-1 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900" role="menuitem">Option 1</a>
				<a href="#" class="block px-2 py-1 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900" role="menuitem">Option 2</a>
			  </div>
			</div>
		  </div>-->
		</div>
	  </div>

	  <div v-show="isOpen">
	  <div  class="flex max-h-[400px]">
		<div class="flex flex-col w-60 min-w-60 overflow-y-scroll">
			<div class="relative m-1">
                <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                    <svg class="w-5 h-5 text-gray-400" viewBox="0 0 24 24" fill="none">
                        <path d="M21 21L15 15M17 10C17 13.866 13.866 17 10 17C6.13401 17 3 13.866 3 10C3 6.13401 6.13401 3 10 3C13.866 3 17 6.13401 17 10Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                    </svg>
                </span>

                <input type="text" class="w-full py-1.5 pl-10 pr-4 text-gray-700 bg-white border rounded-md dark:bg-gray-900 dark:text-gray-300 dark:border-gray-600 focus:border-blue-400 dark:focus:border-blue-300 focus:ring-blue-300 focus:ring-opacity-40 focus:outline-none focus:ring" placeholder="Search" />
            </div>
			<div role="list" >
			<template v-for="item in requestStore.requests" :key="item.EVENTID">
					<a class="flex py-3 px-2 border-b hover:bg-gray-100 dark:hover:bg-gray-600 dark:border-gray-600"
					@click="loadRequest(item)"
					:class="{ 'bg-gray-200 dark:bg-gray-600': item.transactionId == eventStore.transactionID}">
						<div class="pl-3 w-full">
                          <div class="text-gray-500 font-normal mb-1.5 dark:text-gray-400 text-sm">{{cleanURL(item.details)}}</div>
                          <div class="text-xs font-medium text-primary-700 dark:text-primary-400">{{item.time}} &bull; {{item.executionTimeMillis}}ms</div>
                      </div>
						<div class="flex-shrink-0">
							<span :class="statusBadgeClass(item.statusCode)">
								<span class="indicator"></span>
								{{item.statusCode}}
							</span>
                      </div>
					</a>

				</template>
			</div>
		</div>
		<div class="tabs grow">
			<template v-if="requestStore.getSelectedRequest">
				<nav class="bg-gray-50 dark:bg-gray-700">
					<div class="max-w-screen-xl  mx-auto">
						<div class="flex items-center">
							<ul v-if="configStore.config" class="flex flex-row font-medium text-sm divide-x divide-gray-800">
								<template v-for="tab in configStore.config.MENU" :key="tab.key">
									<li class="hover:dark:bg-gray-600">
										<button @click="showTabDetail(tab.key)" :class="{ 'bg-gray-200 dark:bg-gray-600': tab.key == selectedTab}"
										class="py-1 px-2 text-gray-900 dark:text-white"
										aria-current="page">
										{{tab.name}}
										<template v-if="requestStore.getSelectedRequest.stats.hasOwnProperty(tab.key)">
											<span class="text-xs">({{requestStore.getSelectedRequest.stats[tab.key].count}})</span>
											<div class="text-xs">{{eventStore.getLargestTime(requestStore.getSelectedRequest.stats[tab.key].duration)}}</div>
										</template>
									</button>
									</li>
								</template>
							</ul>
						</div>
					</div>
				</nav>
			</template>
			<div class="tab-content overflow-y-scroll" style="height: 50vh;font-size: 12px;">
				<div v-if="!eventStore.transactionID"  class="m-auto">
					<div class="p-4 text-lg">Please select a request from the side panel</div>
				</div>
				<div v-if="eventStore.transactionID">
					<template v-if="selectedTab == 'tracer'"><ConsolePanel /></template>
					<template v-if="selectedTab == 'modules'"><ModulePanel /></template>
					<template v-if="selectedTab == 'cache'"><CachePanel /></template>
					<template v-if="selectedTab == 'cfquery'"><QueryPanel /></template>
					<template v-if="selectedTab == 'hyper'"><HyperPanel /></template>
					<template v-if="selectedTab == 'cborm'"><CbormPanel /></template>
					<template v-if="selectedTab == 'qb'"><QBPanel /></template>
					<template v-if="selectedTab == 'exception'"><ExceptionPanel /></template>
					<template v-if="selectedTab == 'timer'"><TimerPanel /></template>
					<template v-if="selectedTab == 'request'"><RequestPanel/></template>
					<!-- <template v-else><VueJsonView theme="chalk" :src="eventStore.filteredEvents" collapsed sortKeys /></template> -->

					<!-- <div v-for="event in eventStore.filteredEvents" :key="event.EVENTID">
						<template v-if="selectedTab == 'request' || selectedTab == 'exception'">
							<VueJsonView theme="chalk" :src="event.extraInfo" collapsed sortKeys />
						</template>
						<template  v-if="selectedTab != 'request'">
							<EventRow :event="event" />
						</template>
					</div> -->
				</div>
			</div>
		</div>
	  </div>
	</div>
	</div>
  </template>

<script setup>
import { ref, onMounted } from 'vue'
import VueJsonView from '@matpool/vue-json-view'
import { useConfigStore } from "@/stores/ConfigStore.js";
import { useRequestStore } from "@/stores/RequestStore.js";
import { useEventStore } from "@/stores/EventStore.js";

import ConsolePanel from './panels/ConsolePanel.vue'
import QueryPanel from './panels/QueryPanel.vue'
import QBPanel from './panels/QBPanel.vue'
import HyperPanel from './panels/HyperPanel.vue'
import ModulePanel from './panels/ModulePanel.vue'
import CachePanel from './panels/CachePanel.vue'
import CbormPanel from './panels/CbormPanel.vue'
import ExceptionPanel from './panels/ExceptionPanel.vue'
import TimerPanel from './panels/TimerPanel.vue'
import RequestPanel from './panels/RequestPanel.vue'

const props = defineProps({
	baselink: String
})

const configStore = useConfigStore();
const eventStore = useEventStore();
const requestStore = useRequestStore();

onMounted(async () => {
  await configStore.fetchConfig();
  await requestStore.fetchRequests();
});


const isOpen = ref(true)
const title = ref('CB Debugger Dock')
const isDropdownOpen = ref(false)
const selectedTab = ref('timer')
const tabEvents = ref([])

const cleanURL = (url) => {
	//convert http://127.0.0.1:60299/robots.txt to /robots.txt
	//convert http://127.0.0.1:60299/cbdebuggger/requests to /cbdebuggger/requests
	var cleanLink =  url.replace(window.location.origin, '');
	if(cleanLink == ''){
		cleanLink = url;
	}
	return cleanLink;
}
const statusBadgeClass = (statusCode) => {
  let statusCodeRange = statusCode.toString().charAt(0) + '00';
  return `status_${statusCodeRange}`;
}

const loadRequest = (request) => {
	requestStore.setSelected(request);
	eventStore.setTranactionID(request.transactionId);
}

const showTabDetail = (tab) => {
	selectedTab.value = tab;
	eventStore.setEventTypes([tab]);
}

const toggleDock = () => {
  isOpen.value = !isOpen.value
}

const toggleDropdown = () => {
  isDropdownOpen.value = !isDropdownOpen.value
}
</script>
<style scoped>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';
.dock {
	font-family: sans-serif;
}
.status_badge {
	@apply inline-flex items-center text-xs font-medium px-2.5 py-0.5 rounded-full
}
.status_indicator{
	@apply w-2 h-2 me-1 rounded-full;
}
.status_200 {@apply status_badge  bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300;}
.status_200 .indicator {@apply status_indicator bg-green-100 text-green-800;}


.status_300 {@apply status_badge  bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300;}
.status_300 .indicator {@apply status_indicator bg-yellow-100 text-yellow-800;}


.status_400 {@apply status_badge  bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-300;}
.status_400 .indicator {@apply status_indicator bg-orange-100 text-orange-800;}


.status_500 {@apply status_badge  bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300;}
.status_500 .indicator {@apply status_indicator bg-red-100 text-red-800;}


.status_none {@apply status_badge  bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-300;}
.status_none .indicator {@apply status_indicator bg-gray-100 text-gray-800;}
</style>