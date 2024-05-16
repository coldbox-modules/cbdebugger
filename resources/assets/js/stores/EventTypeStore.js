import { defineStore } from 'pinia'

export const useEventStore = defineStore('event_type', {
  state: () => ({
    events: [],
    searchFilter: '',
	sortKey: 'executionTimeMillis',
	sortDir: 'desc',
	eventTypes: [],
	selected: null

  }),
  actions: {
    async fetchEvents( ) {
		if( !this.transactionID ) return console.error( "No transaction ID set" );
		try {
			const response = await fetch( `${window.location.origin}/cbDebugger/getDebuggerEvents?type=${this.transactionID}&sortKey=${this.sortKey}&sortDir=${test.sortDir}`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
			if (!response.ok) throw new Error('Failed to fetch events');
			const data = await response.json();
			this.events = data.data;
		} catch (error) {
			console.error('Error fetching events:', error);
		}
    },
	getLargestTime( ms ){
		ms = ms/1000;
		if( ms < 1000 ) return ms + 'ms';
		if( ms < 60000 ) return (ms/1000).toFixed(2) + 's';
		return (ms/60000).toFixed(2) + 'm';
	},
    filteredEvents: (searchFilter) => {
      let eventList = state.events.filter(row => state.eventTypes.indexOf(row.eventType) >= 0);
	  if (!state.searchFilter) return eventList;
	  return eventList
	  	.filter(event => event.details.toLowerCase()
		.includes(searchFilter.toLowerCase()))
    }
  }
});
