const elixir 	= require( "coldbox-elixir" );
const webpack 	= require( "webpack" );

elixir.config.mergeConfig( {
	plugins : [
		// globally scoped items which need to be available in all templates
		new webpack.ProvidePlugin( {
			"$"             : "jquery",
			"jQuery"        : "jquery",
			"window.jQuery" : "jquery",
			"window.$"      : "jquery"
		} )
	],
	module : {
		// The exposing of jquery as a global object by webpack
		rules : [
			{
				test   	: require.resolve( "jquery" ),
				loader  : "expose-loader",
				options : { exposes: [ "$cb" ] }
			}
		]
	}
} );

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
		.js(
			[ "node_modules/jquery/dist/jquery.min.js" ],
			{
				name           : "vendor.min",
				entryDirectory : ""
			}
		)
		.copy( "resources/assets/images", "includes/images" )
	;

} );
