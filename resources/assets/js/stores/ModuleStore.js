import { defineStore } from 'pinia'

export const useModuleStore = defineStore('modules', {
  state: () => ({
    stats: [],
    filter: '',
    selected: null
  }),
  actions: {
    async fetchModules() {
      try {
        const response = await fetch( `${window.location.origin}/cbDebugger/getModuleReport`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
        if (!response.ok) throw new Error('Failed to fetch modules');
        const data = await response.json();
        this.stats = data.data;
      } catch (error) {
        console.error('Error fetching modules:', error);
      }
    },
    setSelected(moduleInfo) {
      this.selected = moduleInfo;
    },
    setFilter(filter) {
      this.filter = filter;
    }
  },
  getters: {
    getSelectedModule: (state) => {
      if(state.selected != null) return state.selected;
      return null;
    },
    filteredModules: (state) => {
      if (!state.filter) return state.stats;
      return state.stats.filter(event => event.name.includes(state.filter));
    }
  }
});
