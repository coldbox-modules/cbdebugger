/**
* Coldbox Debugger Interecptor
*/
component {

	// DI
	property name="interceptorService"	inject="coldbox:interceptorService";
	property name="debuggerService" 	inject="id:debuggerService@cbDebugger";

	// Configure Interceptor
	function configure() {
		variables.instance = {};
		variables.debuggerConfig 	= controller.getSetting( "DebuggerSettings" );
		variables.debuggerPassword 	= controller.getSetting( "debugPassword" );
	}

	// Before we capture.
	function onRequestCapture(event, interceptData){
		var rc = event.getCollection();

		// Debug Mode Checks
		if ( structKeyExists( rc, "debugMode" ) AND isBoolean( rc.debugMode ) ){
			if ( NOT len( variables.debuggerPassword ) ){
				debuggerService.setDebugMode( rc.debugMode );
			}
			else if ( structKeyExists( rc, "debugPassword" ) AND CompareNoCase( variables.debuggerPassword, hash( rc.debugPassword ) ) eq 0 ){
				debuggerService.setDebugMode( rc.debugMode );
			}
		}

		// verify in debug mode
		if( debuggerService.getDebugMode() ){
			// call debug commands
			debuggerCommands( arguments.event );
			// panel rendering
			var debugPanel = event.getValue( "debugPanel", "" );
			switch( debugPanel ){
				case "profiler": {
					writeOutput( debuggerService.renderProfiler() );
					break;
				}
				default : {
					writeOutput( debuggerService.renderCachePanel() );
					break;
				}
			}
			// turn off debugger and stop
			if( len( debugPanel ) ){
				include "/cbdebugger/includes/debugoutput.cfm";
				abort;
			}
		}
	}

	/**
	* Debugger Commands
	*/
	private function debuggerCommands( event ){
		var command = event.getTrimValue( "cbox_command","" );

		// Verify command
		if( NOT len( command ) ){ return; }

		// Commands
		switch( command ){
			// Module Commands
			case "reloadModules"  : { controller.getModuleService().reloadAll(); break;}
			case "unloadModules"  : { controller.getModuleService().unloadAll(); break;}
			case "reloadModule"   : { controller.getModuleService().reload( event.getValue( "module", "" ) ); break;}
			case "unloadModule"   : { controller.getModuleService().unload( event.getValue( "module", "" ) ); break;}
			default: return;
		}

		// relocate to correct panel
		if( event.getValue("debugPanel","") eq "" ){
			setNextEvent( URL="#listlast(cgi.script_name,"/")#", addtoken=false );
		} else {
			setNextEvent( URL="#listlast(cgi.script_name,"/")#?debugpanel=#event.getValue('debugPanel','')#", addtoken=false );
		}
	}

	//setup all the timers
	public function preProcess(event, interceptData) {
		variables.instance.processHash = debuggerService.timerStart("[preProcess to postProcess] for #arguments.event.getCurrentEvent()#");
	}

	// post processing
	public function postProcess(event, interceptData) {
		debuggerService.timerEnd( variables.instance.processHash );
		request.fwExecTime = getTickCount() - request.fwExecTime;
		interceptorService.processState("beforeDebuggerPanel");
		var debugHTML = debuggerService.renderDebugLog();
		interceptorService.processState("afterDebuggerPanel");
		debuggerService.recordProfiler();
		appendToBuffer( debugHTML );
	}

	public function preEvent(event, interceptData) {
		variables.instance.eventHash = debuggerService.timerStart("[preEvent to postEvent] for #arguments.event.getCurrentEvent()#");
	}

	public function postEvent(event, interceptData) {
		debuggerService.timerEnd(variables.instance.eventHash);
	}

	public function preLayout(event, interceptData) {
		variables.instance.layoutHash = debuggerService.timerStart("[preLayout to postLayout] for #arguments.event.getCurrentEvent()#");
	}

	public function postLayout(event, interceptData) {
		debuggerService.timerEnd(variables.instance.layoutHash);
	}

	public function preRender(event, interceptData) {
		variables.instance.renderHash = debuggerService.timerStart("[preRender to postRender] for #arguments.event.getCurrentEvent()#");
	}

	public function postRender(event, interceptData) {
		debuggerService.timerEnd(variables.instance.renderHash);
	}

	public function preViewRender(event, interceptData) {
		variables.instance.renderViewHash = debuggerService.timerStart("[preViewRender to postViewRender] for #arguments.event.getCurrentEvent()#");
	}

	public function postViewRender(event, interceptData) {
		debuggerService.timerEnd(variables.instance.renderViewHash);
	}

	public function beforeInstanceCreation(event,interceptData){
		if( variables.debuggerConfig.wireboxCreationProfiler ){
			instance[interceptData.mapping.getName()] = debuggerService.timerStart("Wirebox instance creation of #interceptData.mapping.getName()#");
		}
	}

	public function afterInstanceCreation(event, interceptData){
		if( variables.debuggerConfig.wireboxCreationProfiler ){
			debuggerService.timerEnd(instance[interceptData.mapping.getName()]);
		}
	}



}