import { defineStore } from 'pinia'

export const useCacheStore = defineStore('caches', {
  state: () => ({
    stats: [],
    filter: ''
  }),
  actions: {
    async fetchCache() {
		try {
			const response = await fetch( `${window.location.origin}/cbDebugger/getCacheReport`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
			if (!response.ok) throw new Error('Failed to fetch caches');
			const data = await response.json();
			this.stats = data.data;
		} catch (error) {
			console.error('Error fetching caches:', error);
		}
    },
    setFilter(filter) {
      this.filter = filter;
    }
  },
  getters: {
    filteredCaches: (state) => {
      if (!state.filter) return state.stats;
      return state.stats.filter(event => event.name.includes(state.filter));
    }
  }
});
