# CH CH CH CHANGES! #

## v5.0.0, Monday the 10th of June, 2013 ##

* Completely changed the main interface. Now can take filters and run them in any order using a DSL.

----


## v4.0.0, Thursday the 6th of June, 2013 ##

* Cleaned up the link reffing code quite a bit. Can take options now to determine type of process (reference links or inline) and the format of the links (markdown, html).

----


## v3.0.0, Wednesday the 5th of June, 2013 ##

* Not using Hpricot anymore, I don't think it's being maintained. Moved to Nokogiri.
* Added more specs.
* Added much more docs. Got 100% coverage.

----


## v2.0.0, Tuesday the 4th of June, 2013 ##

* Added an abstract superclass so that filters can be sorted by type. Makes it easier to do things like "run all the before filters".
* Moved the filters to their own directory, just to be organised.

----


## v1.1.0, Monday the 3rd of June, 2013 ##

* Reorganised to use Simplecov, Yard etc.
* Instead of loading all the filters and have the client code then need a config to handle them, just set them up via requires in the client code.
* Fixed up the specs a bit.

----


## v1.0.5 ##

* Updated dependencies for coderay. Following minor versions up to 2.0.

----


## v1.0.4 ##

* Only follow patch upgrades to dependencies. Should cut out horrible errors down the line.

----


## v1.0.3 ##

* Bug fix

----


## v1.0.2 ##

* Using named html entities for some of the superscript numbers as some browsers aren't rendering the codes properly.

----


## v1.0.0 ##

* Added coderay filter

----

## v0.4.0 ##

* Made API more consistent and added more specs.

----


## v0.3.0 ##

* Source now supports ogg files in tandem with m4a, as a fallback for Firefox and other stuck up browsers.

----


## v0.2.0 ##

* Made audio able to take options, it's html5, and it has specs.

----


## v0.1.2 ##

* Bugfixes.

----


## v0.1.0 ##

* Added HTML5 audio tag support.

----


## v0.0.3 ##

* Added better div wrapper for links

----


## v0.0.2 ##

* Added filter for embedding video. Only Youtube for now.

----


## v0.0.1 ##

* Getting started!

----


