export default ( isExpanded ) => {
	return {
		panelOpen    : isExpanded,
		isLoading    : false,
		targetAction : "",
		reloadModule( module ){
			this.targetAction = "reload-" + module;
			this.isLoading = true;
			fetch( `${this.appUrl}cbDebugger/reloadModule/module/${module}` )
				.then( response => response.json() )
				.then( data => {
					if ( data.error ){
						alert( data.messages.toString() );
					} else {
						alert( module + " reloaded!" );
					}
					this.targetAction = "";
					this.isLoading = false;
				} );
		},
		unloadModule( module ){
			this.targetAction = "unload-" + module;
			this.isLoading = true;
			fetch( `${this.appUrl}cbDebugger/unloadModule/module/${module}` )
				.then( response => response.json() )
				.then( data => {
					if ( data.error ){
						alert( data.messages.toString() );
					} else {
						alert( module + " unloaded!" );
					}
					this.targetAction = "";
					this.isLoading = false;
					this.$refs[ "module-row-" + module ].remove();
				} );
		}
	};
};
