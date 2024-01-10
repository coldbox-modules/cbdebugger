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
			"ALTER TABLE",
			"CREATE TABLE",
			"DELETE",
			"DROP TABLE",
			"FROM",
			"GROUP BY",
			"HAVING",
			"INSERT INTO",
			"LIMIT",
			"ORDER BY",
			"OFFSET",
			"SELECT",
			"UNION",
			"UPDATE",
			"WHERE"
		];
		var indentedKeywords = [
			"FULL JOIN",
			"INNER JOIN",
			"JOIN",
			"LEFT JOIN",
			"OUTER JOIN"
		];
		var indent = "  ";

		return arguments.target
			.listToArray( variables.NEW_LINE )
			.map( ( item ) => item.trim() )
			// comma spacing
			.map( ( item ) => item.reReplace(
				"\s*(?![^()]*\))(,)\s*",
				",#variables.NEW_LINE##indent#",
				"all"
			) )
			// Parenthesis spacing
			.map( ( item ) => item.reReplace( "\((\w)", "( \1", "all" ) )
			.map( ( item ) => item.reReplace( "(\w)\)", "\1 )", "all" ) )
			// Keyword spacing
			.map( ( item ) => {
				return item.reReplacenocase(
					"(\s)*(#keywords.toList( "|" )#)(\s)+",
					"#variables.NEW_LINE#\2#variables.NEW_LINE##indent#",
					"all"
				)
			} )
			// Indented keyword spacing
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
