require File.dirname(__FILE__) + '/../test_helper'

class BuildSourceTest < Test::Unit::TestCase
  include TestHelper

  define_method :"test original erb source should be still available to the node" do
    src = "<html>\n<body>\n<%= t(:foo) -%>\n</body>\n</html>"
    node = build(src, 'foo.erb')
    assert_equal src, node.src
    assert_equal 't(:foo)', node.select(Ruby::Call).first.src
    assert_equal 0, node.select(Ruby::Call).first.context(:width => 1).index('<body>')
  end

  define_method :"test ruby 1.9 encodings are confusing" do
    filename = File.dirname(__FILE__) + '/../fixtures/template.iso-8859-1.html.erb'
    src = File.read(filename)

    assert_equal 'UTF-8', src.encoding.name
    assert_equal false, src.valid_encoding?
    
    # src = File.open('iso-8859-1.rb', 'rb:binary') { |f| f.read }
    # p src.encoding.name
    # p src.valid_encoding?
    # puts src

    # src.set_encoding('iso-8859-1')
    # p src.encoding.name
    # p src.valid_encoding?
    # p src

    # src = "<html>\n<body><h1>überschrift</h1>\n<%= t(:foo) -%>\n</body>\n</html>"
    # src.force_encoding("iso-8859-1")
    # build(src, 'foo.erb')
  end
end
