component singleton accessors="true" {

	property name="hotFilePath"      default="../includes/hot";
	property name="buildDirectory"   default="../includes/build";
	property name="manifestFileName" default="manifest.json";

	function render( required any entrypoints ) output="true" {
		arguments.entrypoints = arrayWrap( arguments.entrypoints );

		if ( isRunningHot() ) {
			arrayPrepend( arguments.entrypoints, "/@vite/client" );
			write( arguments.entrypoints.map( ( entrypoint ) => generateTag( generateHotAssetPath( entrypoint ) ) ) );
			return;
		}

		var manifest = readManifest();
		var preloads = [];
		var tags     = [];
		for ( var entrypoint in arguments.entrypoints ) {
			var chunk = getEntrypointChunk( entrypoint );
			preloads.append( {
				"src"      : chunk.src,
				"path"     : generateAssetPath( chunk.file ),
				"chunk"    : chunk,
				"manifest" : manifest
			} );

			for ( var assetImport in ( chunk.imports ?: [] ) ) {
				preloads.append( {
					"src"      : assetImport,
					"path"     : generateAssetPath( manifest[ assetImport ].file ),
					"chunk"    : manifest[ assetImport ],
					"manifest" : manifest
				} );

				for ( var css in ( manifest[ assetImport ].css ?: [] ) ) {
					var partialManifest = manifest.filter( ( key, value ) => value.file == css );

					var firstEntryKey = partialManifest.keyArray().first();
					preloads.append( {
						"src"      : firstEntryKey,
						"path"     : generateAssetPath( css ),
						"chunk"    : partialManifest[ firstEntryKey ],
						"manifest" : manifest
					} );

					tags.append(
						generateTagForChunk(
							src      = firstEntryKey,
							path     = generateAssetPath( css ),
							chunk    = partialManifest[ firstEntryKey ],
							manifest = manifest
						)
					);
				}
			}

			tags.append(
				generateTagForChunk(
					src      = entrypoint,
					path     = generateAssetPath( chunk.file ),
					chunk    = chunk,
					manifest = manifest
				)
			);

			for ( var css in ( chunk.css ?: [] ) ) {
				var partialManifest = manifest.filter( ( key, value ) => value.file == css );
				var entries 	  = partialManifest.keyArray();
				if( !arrayLen( entries ) ) continue;
				var firstEntryKey = entries.first();

				preloads.append( {
					"src"      : firstEntryKey,
					"path"     : generateAssetPath( css ),
					"chunk"    : partialManifest[ firstEntryKey ],
					"manifest" : manifest
				} );

				tags.append(
					generateTagForChunk(
						src      = firstEntryKey,
						path     = generateAssetPath( css ),
						chunk    = partialManifest[ firstEntryKey ],
						manifest = manifest
					)
				);
			}
		}

		var assetsByType = partitionTagsByType( arrayUnique( tags ) );

		var preloadTags = arrayUnique( preloads )
			.sort( function( a, b ) {
				var isFirstCssAsset  = isCssAsset( a.src );
				var isSecondCssAsset = isCssAsset( a.src );
				if ( isFirstCssAsset == isSecondCssAsset ) {
					return 0;
				}
				if ( isFirstCssAsset && !isSecondCssAsset ) {
					return 1;
				}
				return -1;
			} )
			.map( ( preload ) => generatePreloadTagForChunk(
				src      = preload.src,
				path     = preload.path,
				chunk    = preload.chunk,
				manifest = preload.manifest
			) );

		write( preloadTags );
		write( assetsByType.stylesheets );
		write( assetsByType.scripts );
	}

	private struct function partitionTagsByType( required array tags ) {
		return arguments.tags.reduce( ( acc, tag ) => {
			if ( stringStartsWith( tag, "<link" ) ) {
				acc.stylesheets.append( tag );
			} else {
				acc.scripts.append( tag );
			}
			return acc;
		}, { "stylesheets" : [], "scripts" : [] } );
	}

	private struct function getEntrypointChunk( required string entrypoint ) {
		return readManifest()[ ensureNoLeadingSlash( arguments.entrypoint ) ];
	}

	private struct function readManifest() {
		if ( !fileExists( expandPath( getManifestPath() ) ) ) {
			throw( "Manifest file not found. Please run `vite` first. # expandPath( getManifestPath() )#"  );
		}
		param variables.manifestContents = deserializeJSON( fileRead( expandPath( getManifestPath() ) ) );
		return variables.manifestContents;
	}

	private string function getManifestPath() {

		return variables.buildDirectory & "/.vite/" & variables.manifestFileName;
	}

	private string function generateTagForChunk(
		required string src,
		required string path,
		required struct chunk,
		required struct manifest
	) {
		if ( isCssAsset( arguments.path ) ) {
			return generateStylesheetTagWithAttributes(
				arguments.path,
				resolveStylesheetTagAttributes(
					arguments.src,
					arguments.path,
					arguments.chunk,
					arguments.manifest
				)
			);
		}

		return generateScriptTagWithAttributes(
			arguments.path,
			resolveStylesheetTagAttributes(
				arguments.src,
				arguments.path,
				arguments.chunk,
				arguments.manifest
			)
		);
	}

	private string function generateStylesheetTagWithAttributes( required string path, struct attributes = [ : ] ) {
		var attrs = [
			"rel" : "stylesheet",
			"href": arguments.path
		];
		structAppend( attrs, arguments.attributes, true );
		return "<link #parseAttributes( attrs )# />";
	}

	private string function generateScriptTagWithAttributes( required string path, struct attributes = [ : ] ) {
		var attrs = [
			"type": "module",
			"src" : arguments.path
		];
		structAppend( attrs, arguments.attributes, true );
		return "<script #parseAttributes( attrs )#></script>";
	}

	private string function parseAttributes( required struct attributes ) {
		return arguments.attributes
			.keyArray()
			.map( ( key ) => '#key#="#attributes[ key ]#"' )
			.toList( " " )
	}

	private struct function resolveStylesheetTagAttributes(
		required string src,
		required string path,
		required struct chunk,
		required struct manifest
	) {
		return [ : ];
	}

	private string function generatePreloadTagForChunk(
		required string src,
		required string path,
		required struct chunk,
		required struct manifest
	) {
		var attributes = resolvePreloadTagAttributes(
			arguments.src,
			arguments.path,
			arguments.chunk,
			arguments.manifest
		);
		return "<link #parseAttributes( attributes )# />";
	}

	private struct function resolvePreloadTagAttributes(
		required string src,
		required string path,
		required struct chunk,
		required struct manifest
	) {
		return isCssAsset( arguments.path ) ? [
			"rel" : "preload",
			"as"  : "style",
			"href": arguments.path
		] : [
			"rel" : "modulepreload",
			"href": arguments.path
		];
	}

	private string function generateTag( required string path ) {
		if ( isCssAsset( arguments.path ) ) {
			return '<link rel="stylesheet" href="#path#" />';
		} else {
			return '<script type="module" src="#path#"></script>';
		}
	}

	private boolean function isCssAsset( required string path ) {
		return reFindNoCase( "\.(css|less|sass|scss|styl|stylus|pcss|postcss)$", arguments.path ) > 1;
	}

	private string function generateAssetPath( required string path ) {
		return getRequestContext().buildLink(
			to        = ensureNoLeadingSlash( getBuildDirectory() & ensureLeadingSlash( arguments.path ) ),
			translate = false
		);
	}

	private string function generateHotAssetPath( required string path ) {
		return readHotFile() & ensureLeadingSlash( arguments.path );
	}

	private string function ensureLeadingSlash( required string path ) {
		return left( arguments.path, 1 ) == "/" ? arguments.path : "/" & arguments.path;
	}

	private string function ensureNoLeadingSlash( required string path ) {
		if ( len( arguments.path ) <= 1 ) {
			return "";
		}
		return left( arguments.path, 1 ) == "/" ? mid(
			arguments.path,
			2,
			len( arguments.path ) - 1
		) : arguments.path;
	}

	private string function readHotFile() {
		param variables._hotServerUrl = fileRead( expandPath( variables.hotFilePath ) );
		return variables._hotServerUrl;
	}

	private void function write( required array tags ) output="true" {
		for ( var tag in arguments.tags ) {
			writeOutput( tag );
		}
	}

	private boolean function isRunningHot() {
		return fileExists( expandPath( variables.hotFilePath ) );
	}

	private array function arrayWrap( required any value ) {
		return isArray( arguments.value ) ? arguments.value : [ arguments.value ];
	}

	private array function arrayUnique( required array items ) {
		return arraySlice( createObject( "java", "java.util.HashSet" ).init( arguments.items ).toArray(), 1 );
	}

	private boolean function stringStartsWith( word, substring ) {
		return left( word, len( substring ) ) == substring;
	}

	private RequestContext function getRequestContext() provider="coldbox:requestContext" {
	}

}
