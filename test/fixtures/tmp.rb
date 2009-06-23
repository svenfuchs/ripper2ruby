# for element in %w[ FRAME ]
#   methods += <<-BEGIN + nOE_element_def(element) + <<-END
#     def #{element.downcase}(attributes = {})
#   BEGIN
#     end
#   END
# end
# eval(methods)
