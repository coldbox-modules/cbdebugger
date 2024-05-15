import { defineStore } from 'pinia'
export const useConfigStore = defineStore('config', {
  state: () => ({
    config: {},
    filter: ''
  }),
  actions: {
    async fetchConfig() {
      try {
        const response = await fetch( `${window.location.origin}/cbDebugger/getDebuggerConfig`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
		if (!response.ok) throw new Error('Failed to fetch configs');
        const data = await response.json();
        this.config = data.data;
      } catch (error) {
        console.error('Error fetching configs:', error);
      }
    },
    setFilter(filter) {
      this.filter = filter;
    },
	reinitFramework(){
		let reinitPass = this.usingReinitPassword ? prompt( "Reinit Password?" ) : "1";
		fetch( `${window.location.origin}/?fwreinit=${reinitPass}`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
			.then( response => {
				if ( response.ok ){
					alert( "Framework Reinitted!" );
					this.refreshProfilers();
				} else {
					alert( "HTTP Call Error" + response.status );
				}
			} );
	},
	clearProfilers(){
		fetch( `${window.location.origin}/cbDebugger/clearProfilers`, { headers: { "x-Requested-With": "XMLHttpRequest" } } )
			.then( response => response.json() )
			.then( data => {
				this.clearState();
				if ( data.error ){
					alert( data.messages.toString() );
				} else {
					this.refreshProfilers();
				}
			} );
	}
  },
  getters: {
    filteredConfigs: (state) => {
      if (!state.filter) return state.configs;
      return state.configs.filter(config => config.name.includes(state.filter));
    }
  }
});
