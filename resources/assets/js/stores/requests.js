import { defineStore } from 'pinia'

export const useRequeststore = defineStore('requests', {
  state: () => ({
    requests: [],
    filter: ''
  }),
  actions: {
    async fetchRequests() {
      try {
        const response = await fetch('https://api.example.com/requests');
        if (!response.ok) throw new Error('Failed to fetch requests');
        const data = await response.json();
        this.requests = data.requests;
      } catch (error) {
        console.error('Error fetching requests:', error);
      }
    },
    setFilter(filter) {
      this.filter = filter;
    }
  },
  getters: {
    filteredRequests: (state) => {
      if (!state.filter) return state.requests;
      return state.requests.filter(event => event.name.includes(state.filter));
    }
  }
});
