/**
* Coldbox Debugger Interecptor
*/
component {

	property name="interceptorService" inject="coldbox:interceptorService";
	property name="debuggerService" inject="id:debuggerService@cbDebugger";
	property name="controller" inject="coldbox";

	// Configure Interceptor
	void function configure() {
		variables.instance = {};
	}


	public function postProcess(event, interceptData) {
		debuggerService.timerEnd(variables.instance.processHash);
		interceptorService.processState("beforeDebuggerPanel");
		var debugHTML = debuggerService.renderDebugLog();
		interceptorService.processState("afterDebuggerPanel");
		appendToBuffer(debugHTML);

	}


	//setup all the timers
	public function preProcess(event, interceptData) {
		variables.instance.processHash = debuggerService.timerStart("[preProcess to postProcess] for #arguments.event.getCurrentEvent()#");
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
		instance[interceptData.mapping.getName()] = debuggerService.timerStart("Wirebox instance creation of #interceptData.mapping.getName()#");
	}

	public function afterInstanceCreation(event, interceptData){
		debuggerService.timerEnd(instance[interceptData.mapping.getName()]);
	}



}