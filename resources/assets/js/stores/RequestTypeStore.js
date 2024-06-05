import { defineStore } from 'pinia'

export const useRequestTypeStore = defineStore('request_type', {
  state: () => ({
    requests: [],
    searchFilter: '',
	sortKey: 'executionTimeMillis',
	sortDir: 'desc',
	requestTypes: [],
	selected: null

  }),
  actions: {
    async fetchRequests( requestType ) {
		if( !requestType ) return console.error( "No type ID set" );
		try {
			const response = await fetch( `${window.location.origin}/cbDebugger/getDebuggerRequestEvents?type=${requestType}&sortKey=${this.sortKey}&sortDir=${this.sortDir}`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
			if (!response.ok) throw new Error('Failed to fetch requests');
			const data = await response.json();
			return data.data;
		} catch (error) {
			console.error('Error fetching requests:', error);
		}
    },
	getLargestTime( ms ){
		ms = ms/1000;
		if( ms < 1000 ) return ms + 'ms';
		if( ms < 60000 ) return (ms/1000).toFixed(2) + 's';
		return (ms/60000).toFixed(2) + 'm';
	},
    filteredRequests: (searchFilter) => {
      let requestList = state.requests.filter(row => state.requestTypes.indexOf(row.requestType) >= 0);
	  if (!state.searchFilter) return requestList;
	  return requestList
	  	.filter(request => request.details.toLowerCase()
		.includes(searchFilter.toLowerCase()))
    }
  }
});
