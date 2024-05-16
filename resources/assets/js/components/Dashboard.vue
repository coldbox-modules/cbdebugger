<template>
	<div class="dark">
	<div class="dashboard grid grid-cols-2 gap-2 w-full h-full  dark:bg-gray-900 bg-gray-50 ">
		<div class=" p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
		</div>
		<div class=" p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
		</div>
		<div class=" p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
		</div>
		<div class=" p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
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
</script>
<style scoped>
	@import 'tailwindcss/base';
	@import 'tailwindcss/components';
	@import 'tailwindcss/utilities';

	.dashboard {
		font-family: sans-serif;
	}
</style>