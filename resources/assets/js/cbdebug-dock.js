import { createApp } from 'vue'
import { createPinia } from 'pinia'
import Dock from './components/Dock.vue'
const pinia = createPinia()


createApp(Dock)
	.use(pinia)
	.mount('#cbdebug-dock')
