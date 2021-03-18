/**
 * An appender that interfaces with the ColdBox Tracer Panel
 */
component extends="coldbox.system.logging.AbstractAppender" {

	/**
	 * Constructor
	 */
	function init(
		required name,
		struct properties = {},
		layout            = "",
		levelMin          = 0,
		levelMax          = 4
	){
		// Init supertype
		super.init( argumentCollection = arguments );
		return this;
	}

	/**
	 * Called upon registration
	 */
	function onRegistration(){
		variables.debuggerService = getColdBox().getWireBox().getInstance( "debuggerService@cbdebugger" );
		return this;
	}

	/**
	 * Log a message
	 */
	function logMessage( required any logEvent ){
		var loge          = arguments.logEvent;
		var entry         = "";
		var traceSeverity = "information";
		var severityStyle = "";
		var severity      = severityToString( loge.getseverity() );

		// Severity Styles
		switch ( severity ) {
			case "FATAL": {
				severityStyle = "fw_redText";
				break;
			}
			case "ERROR": {
				severityStyle = "fw_orangeText";
				break;
			}
			case "WARN": {
				severityStyle = "fw_greenText";
				break;
			}
			case "INFO": {
				severityStyle = "fw_blackText";
				break;
			}
			case "DEBUG": {
				severityStyle = "fw_blueText";
				break;
			}
		}

		if ( hasCustomLayout() ) {
			entry = getCustomLayout().format( loge );
		} else {
			entry = "<span class='#severityStyle#'><b>#severity#</b></span> #timeFormat( loge.getTimeStamp(), "hh:MM:SS.l tt" )# <b>#loge.getCategory()#</b> <br/> #loge.getMessage()#";
		}

		// send to coldBox debugger
		variables.debuggerService.pushTracer( entry, loge.getExtraInfo() );

		return this;
	}

}
