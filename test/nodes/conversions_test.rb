require File.dirname(__FILE__) + '/../test_helper'

class ConversionsTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test from_ruby" do
    Ruby::Node.from_ruby('1')
  end
end