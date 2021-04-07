# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

----

## [3.0.0]

### Added

* Completely rewritten debugger
* Updated tracers to match all logbox options so we can use them for display instead of hardcoding them in the push operation
* Complete migration to elixir for assets
* Complete migration to runnable events to make things easier for rendering and debugging
* New interceptor profiling via AOP `announce` interceptions
* New object profiling via metadata AOP aspects via new settings: `profileObjects`, `traceObjectResults`
* New visualizer route `/cbdebugger` that if you are in debug mode, you can visualize the panels. Great for API apps
* New method: `timer.timeIt()` so you can time code execution via a closure wrapper
* New Helper Methods: `startCBTimer(), stopCBTimer(), cbTimeIt()`
* Added the route record to the info panel so you can debug the selected route
* Highlights transactions that take over `200ms` or using the `slowExecutionThreshold` setting
* Refactored to use array of structs instead of queries for even faster timer performance

### Changed

* Encapsualted request timers UI into a single template
* `Timer` is now built in script and optimized
* Show timers as they start instead of how they end, huge UI update to visualize the timers
* Refactored the logbox appenders from `includes/appenders` to `appenders`

### Security

* `Dumpar` facilities removed due to security concerns

### Removed

* Old `debugger` settings instead use the `modulesettings.cbdebugger` according to ColdBox 5+ standards
* Old helper code to remove helpers
* Removed the loaded modules as it just produced noise
* Removed the rc/prc snapshot comparisons, causes too much noise and not helpful anymore

----

## [2.2.0] => 2020-MAY-18

### Added

* Upgraded Appender to script and fixes for LogBox 6
* More tests for logbox loading and appender registration

### Fixed

* Visual display of the debugger version

----

## [2.1.0] => 2020-MAY-14

### Added

* ColdBox 6 support
* Formatting

## Removed

* ColdBox 4 lingering code

----

## [2.0.0] => 2020-MAY-04

### Added

* Formatting updates
* Quick/QB Panels

### Removed

* Dropped ACF 11 support

----

## [1.7.1]  => 2019-MAR-06

* Updated location protocol

----

## [1.7.0] => 2019-MAR-06

* Missing interception points for extending the panels: `afterDebuggerPanel`, `beforeDebuggerPanel`
* New Module Layout
* Dropping lucee 4.5 support

----

## [1.6.0 ]

* ColdBox 5 Support

----

## [1.5.0]

* Case-Sensitive filesystems fix
* Updated travis builds
* Unified workbench approach

----

## [1.4.0]

* ColdBox Tracer Appender added by Default by Eric Peterson

----

## [1.3.0]

* Travis integration
* DocBox update
* Build process update

----

## [1.2.0]

* Fix unscoped currentrow which was throwing an error when debugging was enabled.
* Removed reference to missing images in CSS
* Updated build scripts
* How to turn off debugger for tests, it does this automatically now.
* filename cases don't match #5 on certain includes

----

## [1.1.0]

* https://ortussolutions.atlassian.net/browse/CCM-14 Issue with unloading modules
* https://ortussolutions.atlassian.net/browse/CCM-25 Lucee support
* https://ortussolutions.atlassian.net/browse/CCM-24 Added names of rendered 
* Unloading of helpers on unload
views and layouts
* Updated production ignore lists

----

## [1.0.1]

* Bug fixes on caching panels and chicken/egg issues for ColdBox loading

----

## [1.0.0]

* Create first module version