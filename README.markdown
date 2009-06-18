Ripper2Ruby
===========

Similar to ruby2ruby this library allows to parse Ruby code, modify and 
recompile it back to Ruby.

Differences:

* uses Ripper for parsing (shipped with Ruby 1.9)
* produces a full object-oriented representation of the Ruby code

Disadvantages:

* f*cking slow so far, will be improved though