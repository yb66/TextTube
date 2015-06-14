# CH CH CH CHANGES! #

## Sunday the 14th of June 2015# 

# v7.0.1 ##

* Added fences to code block in example.

----

# v7.0.0 #

* Added more examples of how to use options.
* Cleaned up the options a lot, clarified and better tested.
* Fixed the ever moving target of the Travis-CI settings.

----


## Friday the 12th of June 2015, v6.1.0 ##

* Got rid of some ext methods that weren't needed or used.
* Updated the docs for Github with the syntax highlighting hints.

----


## Friday the 17th of October 2014, v6.0.0 ##

* Moved extra filters into TextTubeBaby to make the library lighter and easier to install.
* Updated specs to check core lib now filter specs have gone.

----


## Wednesday the 30th of July 2014, v5.1.1 ##

* Updated info in the README about Spiffing CSS website, since it's gone.
* Fixed description of running the filters in the README.
* Fixed mis-ordering of sections in README.

----


## Thursday the 25th of July, 2013, v5.1.0 ##

* Make CSS spiffing!

----


## Thursday the 27th of June, 2013, ##

### v5.0.3 ###

* Included link to source in gemspec.

----

### v5.0.2 ###

* Renamed library.

----


## Monday the 10th of June, 2013 ##

### v5.0.1 ###

* Improved spec for coderay scanner.

----


### v5.0.0 ###

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


