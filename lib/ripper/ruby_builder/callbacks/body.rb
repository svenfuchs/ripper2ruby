# class Ripper
#   class RubyBuilder < Ripper::SexpBuilder
#     module Body
#       def on_program(statements)
#         Ruby::Program.new(src, filename, statements)
#       end
# 
#       def on_body_stmt(statements, rescue_block, something, ensure_block)
#         Ruby::Body.new(statements, rescue_block, ensure_block)
#       end
#     
#       def on_stmts_add(target, statement)
#         case statement
#         when Ruby::Statement # from on_void_stmt, on_const_ref, on_var_ref, on_var_field
#           target << statement
#         when Ruby::Node      # TODO only from on_void_stmt, on_int, etc., can we remove this?
#           target << Ruby::Statement.new(statement, pop_delim(:@semicolon)) 
#         end
#         target
#       end
# 
#       def on_stmts_new
#         rdelim = pop_delim(:@semicolon)
#         list = Ruby::Composite::Array.new
#         list << Ruby::Statement.new(nil, rdelim) if rdelim
#         list
#       end
#     
#       def on_void_stmt
#         rdelim = pop_delim(:@semicolon)
#         Ruby::Statement.new(nil, rdelim) if rdelim
#       end
# 
#       def on_const_ref(const)
#         Ruby::Statement.new(const, pop_delim(:@semicolon))  # technically not a statement, use Expression instead?
#       end
# 
#       def on_var_ref(ref)
#         Ruby::Statement.new(ref, pop_delim(:@semicolon))    # technically not a statement, use Expression instead?
#       end
# 
#       def on_var_field(field)
#         Ruby::Statement.new(field, pop_delim(:@semicolon))  # technically not a statement, use Expression instead?
#       end
#     end
#   end
# end