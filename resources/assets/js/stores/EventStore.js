import { defineStore } from 'pinia'

export const useEventStore = defineStore('events', {
  state: () => ({
    events: [],
    searchFilter: '',
	transactionID: null,
	eventTypes: [],
	selected: null

  }),
  actions: {
    async fetchEvents( ) {
		if( !this.transactionID ) return console.error( "No transaction ID set" );
		try {
			const response = await fetch( `${window.location.origin}/cbDebugger/getDebuggerEvents?id=${this.transactionID}`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
			if (!response.ok) throw new Error('Failed to fetch events');
			const data = await response.json();
			this.events = data.data;
		} catch (error) {
			console.error('Error fetching events:', error);
		}
    },
    setSelected(eventInfo) {
      this.selected = eventInfo;
    },
	setTranactionID( transactionID ){
		this.transactionID = transactionID;
		this.fetchEvents();
	},
    setSearchFilter(filter) {
      this.searchFilter = filter;
    },
	setEventTypes( eventTypes ){
		this.eventTypes = eventTypes;
	},
	getLargestTime( ms ){
		ms = ms/1000;
		if( ms < 1000 ) return ms + 'ms';
		if( ms < 60000 ) return (ms/1000).toFixed(2) + 's';
		return (ms/60000).toFixed(2) + 'm';
	}
  },
  getters: {
    getSelectedEvent: (state) => {
		if(state.selected != null) return state.selected;
		return null;
	  },
    totalEventTime: (state) => {
		var totalTime =  state.events.filter(row => state.eventTypes.indexOf(row.eventType) >= 0).reduce((acc, item) => {
			var duration = parseInt(item.executionTimeMillis);
			console.log(item.executionTimeMillis,duration)
			if(!isNaN(duration)) acc = acc + duration;
			return acc;
		}, 0);
		return state.getLargestTime(totalTime);
	},
	totalEventCount: (state) =>{
		return state.filteredEvents.length;
	},
    filteredEvents: (state) => {
      let eventList = state.events.filter(row => state.eventTypes.indexOf(row.eventType) >= 0);
	  if (!state.searchFilter) return eventList;
	  return eventList
	  	.filter(event => event.details.toLowerCase().includes(state.searchFilter.toLowerCase()))
    }
  }
});
