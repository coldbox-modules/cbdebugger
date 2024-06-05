import { defineStore } from 'pinia'

export const useEventTypeStore = defineStore('event_type', {
  state: () => ({
    events: [],
    searchFilter: '',
	sortKey: 'executionTimeMillis',
	sortDir: 'desc',
	eventTypes: [],
	selected: null

  }),
  actions: {
    async fetchEvents( eventType ) {
		console.log( eventType );
		if( !eventType ) return console.error( "No type ID set" );
		try {
			const response = await fetch( `${window.location.origin}/cbDebugger/getDebuggerEvents?type=${eventType}&sortKey=${this.sortKey}&sortDir=${this.sortDir}`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
			if (!response.ok) throw new Error('Failed to fetch events');
			const data = await response.json();
			return data.data;
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
