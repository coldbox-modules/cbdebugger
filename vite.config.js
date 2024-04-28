import { defineConfig } from "vite";
import coldbox from "coldbox-vite-plugin";
import vue from "@vitejs/plugin-vue";

export default () => {
	return defineConfig({
		plugins: [
			vue(),
			coldbox({
				input: ["resources/assets/js/cbdebug-dashboard.js","resources/assets/js/cbdebug-dock.js"],
				refresh: true,
			})
		]
	});
};