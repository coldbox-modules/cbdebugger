import { defineStore } from 'pinia'

export const useRequestStore = defineStore('requests', {
  state: () => ({
    requests: [],
	selected: null,
    filter: ''
  }),
  actions: {
    async fetchRequests() {
		try {
			const response = await fetch( `${window.location.origin}/cbDebugger/getDebuggerRequests`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
			if (!response.ok) throw new Error('Failed to fetch requests');
			const data = await response.json();
			this.requests = data.data;
		} catch (error) {
			console.error('Error fetching requests:', error);
		}
    },
	setSelected(requestInfo) {
	  this.selected = requestInfo;
	},
    setFilter(filter) {
      this.filter = filter;
    }
  },
  getters: {
	getSelectedRequest: (state) => {
	  if(state.selected != null) return state.selected;
	  return null;
	},
    filteredRequests: (state) => {
      if (!state.filter) return state.requests;
      return state.requests.filter(event => event.name.includes(state.filter));
    }
  }
});
