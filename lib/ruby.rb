Dir[File.dirname(__FILE__) + '/ruby/*.rb'].sort.each do |file|
  require "ruby/#{File.basename(file)}"
end

# Object oriented representation of Ruby code.
#
# The base class is Ruby::Node. It facilitates
#
#   * a composite pattern (see Ruby::Node::Composite)
#   * means for extracting from the original source (see Ruby::Node::Source)
#
# There are two main concrete classes derived from Node: Token and Aggregate.
#
# Tokens are "atomic" node types that represent non-composite Ruby constructs
# such as Keyword, Identifier, StringContent and literal types such as integers,
# floats, true, false, nil etc. Aggregates are composed node types that hold
# one or many tokens, such as Class, Module, Block, If, For, Case, While etc.
#
# Each node type supports the to_ruby method which will return an exact copy
# of the orginal code it was parsed from.
#
# There are also a few helper methods for converting a node to another type
# (see Ruby::Node::Conversions) and very few helper methods for altering
# existing code structures (see Ruby::Alternation).

module Ruby
  include Conversions
end
