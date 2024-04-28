import { defineStore } from 'pinia'

export const useEventStore = defineStore('events', {
  state: () => ({
    events: [],
    filter: ''
  }),
  actions: {
    async fetchEvents() {
      try {
        const response = await fetch('https://api.example.com/events');
        if (!response.ok) throw new Error('Failed to fetch events');
        const data = await response.json();
        this.events = data.events;
      } catch (error) {
        console.error('Error fetching events:', error);
      }
    },
    setFilter(filter) {
      this.filter = filter;
    }
  },
  getters: {
    filteredEvents: (state) => {
      if (!state.filter) return state.events;
      return state.events.filter(event => event.name.includes(state.filter));
    }
  }
});
