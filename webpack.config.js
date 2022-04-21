const elixir 	= require( "coldbox-elixir" );

/*
 |--------------------------------------------------------------------------
 | Elixir Asset Management
 |--------------------------------------------------------------------------
 |
 | Elixir provides a clean, fluent API for defining some basic Gulp tasks
 | for your ColdBox application. By default, we are compiling the Sass
 | file for our application, as well as publishing vendor resources.
 |
 */

module.exports = elixir( mix => {
	// Mix App styles
	mix
		.js( "cbdebugger.js" )
		.sass( "cbdebugger.scss" )
		.copy( "resources/assets/images", "includes/images" )
	;
} );
