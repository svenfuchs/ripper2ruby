Gem::Specification.new do |s|
  s.name = "ripper2ruby"
  s.version = "0.0.2"
  s.date = "2009-07-04"
  s.summary = "Ripper2Ruby builds an object-oriented representation of Ruby code that you can modify and recompile back to Ruby"
  s.email = "svenfuchs@artweb-design.de"
  s.homepage = "http://github.com/svenfuchs/ripper2ruby"
  s.description = "Ripper2Ruby builds an object-oriented representation of Ruby code that you can modify and recompile back to Ruby."
  s.has_rdoc = false
  s.authors = ['Sven Fuchs']
  s.files = %w(
    lib/core_ext/array/flush.rb
    lib/core_ext/hash/delete_at.rb
    lib/core_ext/object/meta_class.rb
    lib/core_ext/object/try.rb
    lib/erb/stripper.rb
    lib/highlighters/ansi.rb
    lib/ripper/event_log.rb
    lib/ripper/ruby_builder/buffer.rb
    lib/ripper/ruby_builder/events/args.rb
    lib/ripper/ruby_builder/events/array.rb
    lib/ripper/ruby_builder/events/assignment.rb
    lib/ripper/ruby_builder/events/block.rb
    lib/ripper/ruby_builder/events/call.rb
    lib/ripper/ruby_builder/events/case.rb
    lib/ripper/ruby_builder/events/const.rb
    lib/ripper/ruby_builder/events/for.rb
    lib/ripper/ruby_builder/events/hash.rb
    lib/ripper/ruby_builder/events/identifier.rb
    lib/ripper/ruby_builder/events/if.rb
    lib/ripper/ruby_builder/events/lexer.rb
    lib/ripper/ruby_builder/events/literal.rb
    lib/ripper/ruby_builder/events/method.rb
    lib/ripper/ruby_builder/events/operator.rb
    lib/ripper/ruby_builder/events/statements.rb
    lib/ripper/ruby_builder/events/string.rb
    lib/ripper/ruby_builder/events/symbol.rb
    lib/ripper/ruby_builder/events/while.rb
    lib/ripper/ruby_builder/queue.rb
    lib/ripper/ruby_builder/stack.rb
    lib/ripper/ruby_builder/token.rb
    lib/ripper/ruby_builder.rb
    lib/ripper2ruby.rb
    lib/ruby/aggregate.rb
    lib/ruby/alternation/args.rb
    lib/ruby/alternation/hash.rb
    lib/ruby/alternation/list.rb
    lib/ruby/args.rb
    lib/ruby/array.rb
    lib/ruby/assignment.rb
    lib/ruby/assoc.rb
    lib/ruby/block.rb
    lib/ruby/call.rb
    lib/ruby/case.rb
    lib/ruby/const.rb
    lib/ruby/for.rb
    lib/ruby/hash.rb
    lib/ruby/if.rb
    lib/ruby/list.rb
    lib/ruby/literal.rb
    lib/ruby/method.rb
    lib/ruby/node/composite.rb
    lib/ruby/node/conversions.rb
    lib/ruby/node/position.rb
    lib/ruby/node/source.rb
    lib/ruby/node/text.rb
    lib/ruby/node/traversal.rb
    lib/ruby/node.rb
    lib/ruby/operator.rb
    lib/ruby/params.rb
    lib/ruby/statements.rb
    lib/ruby/string.rb
    lib/ruby/symbol.rb
    lib/ruby/token.rb
    lib/ruby/while.rb
    lib/ruby.rb
  )
  s.test_files = %w(
    test/all.rb
    test/builder/source_test.rb
    test/builder/stack_test.rb
    test/builder/text_test.rb
    test/context_test.rb
    test/erb_stripper_test.rb
    test/fixtures/all.rb.src
    test/fixtures/source_1.rb
    test/fixtures/source_2.rb
    test/fixtures/stuff.rb
    test/fixtures/template.html.erb
    test/fixtures/template.iso-8859-1.html.erb
    test/fixtures/tmp.rb
    test/lib_test.rb
    test/lib_test_helper.rb
    test/libs.txt
    test/nodes/args_test.rb
    test/nodes/array_test.rb
    test/nodes/assignment_test.rb
    test/nodes/block_test.rb
    test/nodes/call_test.rb
    test/nodes/case_test.rb
    test/nodes/comments_test.rb
    test/nodes/const_test.rb
    test/nodes/conversions_test.rb
    test/nodes/for_test.rb
    test/nodes/hash_test.rb
    test/nodes/heredoc_test.rb
    test/nodes/identifier_test.rb
    test/nodes/if_test.rb
    test/nodes/literals_test.rb
    test/nodes/method_test.rb
    test/nodes/namespaces_test.rb
    test/nodes/node_test.rb
    test/nodes/nodes_test.rb
    test/nodes/operator_test.rb
    test/nodes/separators_test.rb
    test/nodes/statements_test.rb
    test/nodes/string_test.rb
    test/nodes/symbol_test.rb
    test/nodes/unless_test.rb
    test/nodes/until_test.rb
    test/nodes/while_test.rb
    test/test_helper.rb
    test/traversal_test.rb
  )
end