require File.dirname(__FILE__) + '/../test_helper'

class RipperRubyBuilderConstTest < Test::Unit::TestCase
  include TestRubyBuilderHelper

  @@space = "  \n  "

  define_method :'test a const: I18n' do
    src = @@space + 'I18n'
    const = const(src)
  
    assert const.root.is_a?(Ruby::Program)
    assert_equal Ruby::Const, const.class
    assert_equal 'I18n', const.token
    assert_equal 'I18n', const.to_ruby
  
    assert_equal src, const.root.src
  
    assert_equal [1, 2], const.position
    assert_equal 1, const.row
    assert_equal 2, const.column
    assert_equal 4, const.length
  end
  
  define_method :"test a class" do
    src = <<-eoc
      class A < B
        def foo
        end
      end
    eoc
    klass = node(src, Ruby::Class)
  
    assert klass.root.is_a?(Ruby::Program)
    assert_equal klass, klass.super_class.parent
    assert_equal klass, klass.body.parent
  
    assert_equal 'A', klass.const.token
    assert_equal 'B', klass.super_class.token
    assert_equal 'foo', klass.body.statements.first.identifier.token
  
    assert_equal src.strip, klass.to_ruby
  
    assert_equal [0, 6], klass.position
  end

  define_method :"test a module" do
    src = <<-eoc
      module A
        def foo
        end
      end
    eoc
    mod = node(src, Ruby::Module)

    assert mod.root.is_a?(Ruby::Program)
    assert_equal mod, mod.body.parent
  
    assert_equal 'A', mod.const.token
  
    assert_equal src.strip, mod.to_ruby
    assert_equal [0, 6], mod.position
  end
  
  define_method :"test a const path ref" do
    src = "A::B.foo = true"
    assert_equal src, build(src).statements.first.to_ruby
  end
end