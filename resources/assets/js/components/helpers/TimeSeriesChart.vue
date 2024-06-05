<template>
	<div class="time-series-chart border border-gray-600 p-1 rounded-lg">
		<Line :data="data" class="w-full" :options="options" />
	</div>
  </template>

  <script setup>
	import { ref, defineExpose } from 'vue';
	import {
		Chart as ChartJS,
		CategoryScale,
		LinearScale,
		PointElement,
		LineElement,
		Title,
		Tooltip,
		Legend
	} from 'chart.js'
	import { Line } from 'vue-chartjs'

	ChartJS.register(
		CategoryScale,
		LinearScale,
		PointElement,
		LineElement,
		Title,
		Tooltip,
		Legend
	)
	const maxItems = 50;
	const dataPoints = [ 10];

	const data = ref({
		datasets: []
	});

	const options = {
		responsive: true,
		maintainAspectRatio: false, // Important for fixed height
		plugins: {
			legend: {
				display: false
			}
		},
		scales: {
			x: {
				display: false
			},
			y: {
				display: false
			}
		}
	}

	function addDataPoint(newPoint) {
		if (dataPoints.length >= maxItems) {
			dataPoints.shift();
		}
		dataPoints.push(newPoint);
		data.value = {
			labels:  dataPoints.map((_, index) => index.toString()),
			datasets: [
				{
					label: 'Data One',
					backgroundColor: 'rgba(255, 99, 132, 0.5)',
					borderColor: 'rgb(69, 222, 69)',
					tension: 0.5, // Adds curviness to the lines
					pointRadius: 0, // Removes the dots
					borderWidth: 1.5,
					data: dataPoints
				}
			]
		}
	}

	defineExpose({
		addDataPoint
	});
 </script>

  <style scoped>
	@import 'tailwindcss/base';
	@import 'tailwindcss/components';
	@import 'tailwindcss/utilities';
  .time-series-chart {
	max-width: 100%; /* Ensures responsiveness */
  	height: 50px; /* Fixed height */
  }
  </style>
