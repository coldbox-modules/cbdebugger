/**
* Coldbox Debugger Interecptor
*/
component {

	property name="interceptorService" inject="coldbox:interceptorService";
	property name="debuggerService" inject="id:debuggerService@cbDebugger";

	// Configure Interceptor
	void function configure() {

	}


	public function preRender(interceptData) {

		interceptorService.processState("beforeDebuggerPanel");
		var debugHTML = debuggerService.renderDebugLog();
		interceptData.renderedContent = interceptData.renderedContent & debugHTML;
		interceptorService.processState("afterDebuggerPanel");

		return interceptData;
	}



}