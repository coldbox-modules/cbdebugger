/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This leverages Hibernate for SQL Formatting
 */
component accessors="true" singleton {

	property name="formatter";

	/**
	 * Constructor
	 */
	function init(){
		// get formatter for sql string beautification: ACF vs Lucee
		if (
			findNoCase(
				"coldfusion",
				server.coldfusion.productName
			)
		) {
			// Formatter Support
			variables.formatter = createObject(
				"java",
				"org.hibernate.engine.jdbc.internal.BasicFormatterImpl"
			);
		}
		// Old Lucee Hibernate 3
		else {
			variables.formatter = createObject(
				"java",
				"org.hibernate.jdbc.util.BasicFormatterImpl"
			);
		}

		return this;
	}

	/**
	 * Format SQL
	 *
	 * @sql The sql to format
	 * @wrapInPre To wrap or not the sql in <pre></pre> tags, default is true
	 */
	function formatSql(
		required sql,
		boolean wrapInPre = true
	){
		if ( arguments.wrapInPre ) {
			return "<pre>#variables.formatter.format( arguments.sql )#</pre>";
		}

		return variables.formatter.format( arguments.sql );
	}

}
