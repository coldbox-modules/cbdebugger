/**
 * Basic sql + json formatter
 * This will be removed once CB7 is the default, since it's included in the core.
 */
component singleton {

	variables.NEW_LINE = chr( 13 ) & chr( 10 );
	variables.TAB      = chr( 9 );

	/**
	 * Format an incoming sql string to a pretty version
	 *
	 * @target The target sql to prettify
	 *
	 * @return The prettified sql
	 */
	function prettySql( string target = "" ){
		var keywords = [
			"SELECT",
			"FROM",
			"WHERE",
			"GROUP BY",
			"HAVING",
			"ORDER BY",
			"INSERT INTO",
			"UPDATE",
			"DELETE",
			"CREATE TABLE",
			"ALTER TABLE",
			"DROP TABLE",
			"UNION"
		];
		var indentedKeywords = [
			"JOIN",
			"LEFT JOIN",
			"INNER JOIN",
			"OUTER JOIN",
			"FULL JOIN"
		];
		var indent = "  ";

		return arguments.target
			.listToArray( variables.NEW_LINE )
			.map( ( item ) => item.trim() )
			.map( ( item ) => item.reReplace(
				"(\s)*,(\s)*",
				",#variables.NEW_LINE##indent#",
				"all"
			) )
			.map( ( item ) => {
				return item.reReplacenocase(
					"(\s)*(#keywords.toList( "|" )#)(\s)*",
					"\2#variables.NEW_LINE##indent#",
					"all"
				)
			} )
			.map( ( item ) => {
				return item.reReplacenocase(
					"(#indentedKeywords.toList( "|" )#)",
					"#variables.NEW_LINE##indent#\1",
					"all"
				)
			} )
			.toList( variables.NEW_LINE );
	}

	/**
	 * Format an incoming json string to a pretty version
	 *
	 * @target The target json to prettify
	 *
	 * @return The prettified json
	 */
	string function prettyJson( string target = "" ){
		var padding = 0;
		return arguments.target
			.reReplace(
				"([\{|\}|\[|\]|\(|\)|,])",
				"\1#variables.NEW_LINE#",
				"all"
			)
			.reReplace(
				"(\]|\})#variables.NEW_LINE#",
				"#variables.NEW_LINE#\1",
				"all"
			)
			.listToArray( variables.NEW_LINE )
			.map( ( token ) => {
				if ( token.reFind( "[\}|\)|\]]" ) && padding > 0 ) {
					padding--;
				};
				var newToken = repeatString( variables.TAB, padding ) & token.trim();
				if ( token.reFind( "[\{|\(|\[]" ) ) {
					padding++;
				};
				return newToken;
			} )
			.toList( variables.NEW_LINE );
	}

}
