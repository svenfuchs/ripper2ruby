        
          Thread.current[:"#{self}_scoped_methods"] ||= self.default_scoping.dup
        # end
        # 
        # def current_scoped_methods #:nodoc:
        #   scoped_methods.last
        # end
        
        # # Returns the class type of the record using the current module as a prefix. So descendants of
        # # MyApp::Business::Account would appear as MyApp::Business::AccountSubclass.
        # def compute_type(type_name)
        #   modularized_name = type_name_with_module(type_name)
        #   silence_warnings do
        #     begin
        #       class_eval(modularized_name, __FILE__, __LINE__)
        #     rescue NameError
        #       class_eval(type_name, __FILE__, __LINE__)
        #     end
        #   end
        # end
        # 
        # # Returns the class descending directly from ActiveRecord::Base or an
        # # abstract class, if any, in the inheritance hierarchy.
        # def class_of_active_record_descendant(klass)
        #   if klass.superclass == Base || klass.superclass.abstract_class?
        #     klass
        #   elsif klass.superclass.nil?
        #     raise ActiveRecordError, "#{name} doesn't belong in a hierarchy descending from ActiveRecord"
        #   else
        #     class_of_active_record_descendant(klass.superclass)
        #   end
        # end
        # 
        # # Returns the name of the class descending directly from Active Record in the inheritance hierarchy.
        # def class_name_of_active_record_descendant(klass) #:nodoc:
        #   klass.base_class.name
        # end
        # 
        # # Accepts an array, hash, or string of SQL conditions and sanitizes
        # # them into a valid SQL fragment for a WHERE clause.
        # #   ["name='%s' and group_id='%s'", "foo'bar", 4]  returns  "name='foo''bar' and group_id='4'"
        # #   { :name => "foo'bar", :group_id => 4 }  returns "name='foo''bar' and group_id='4'"
        # #   "name='foo''bar' and group_id='4'" returns "name='foo''bar' and group_id='4'"
        # def sanitize_sql_for_conditions(condition, table_name = quoted_table_name)
        #   return nil if condition.blank?
        # 
        #   case condition
        #     when Array; sanitize_sql_array(condition)
        #     when Hash;  sanitize_sql_hash_for_conditions(condition, table_name)
        #     else        condition
        #   end
        # end
        # alias_method :sanitize_sql, :sanitize_sql_for_conditions
        # 
        # # Accepts an array, hash, or string of SQL conditions and sanitizes
        # # them into a valid SQL fragment for a SET clause.
        # #   { :name => nil, :group_id => 4 }  returns "name = NULL , group_id='4'"
        # def sanitize_sql_for_assignment(assignments)
        #   case assignments
        #     when Array; sanitize_sql_array(assignments)
        #     when Hash;  sanitize_sql_hash_for_assignment(assignments)
        #     else        assignments
        #   end
        # end
        # 
        # def aggregate_mapping(reflection)
        #   mapping = reflection.options[:mapping] || [reflection.name, reflection.name]
        #   mapping.first.is_a?(Array) ? mapping : [mapping]
        # end
        # 
        # # Accepts a hash of SQL conditions and replaces those attributes
        # # that correspond to a +composed_of+ relationship with their expanded
        # # aggregate attribute values.
        # # Given:
        # #     class Person < ActiveRecord::Base
        # #       composed_of :address, :class_name => "Address",
        # #         :mapping => [%w(address_street street), %w(address_city city)]
        # #     end
        # # Then:
        # #     { :address => Address.new("813 abc st.", "chicago") }
        # #       # => { :address_street => "813 abc st.", :address_city => "chicago" }
        # def expand_hash_conditions_for_aggregates(attrs)
        #   expanded_attrs = {}
        #   attrs.each do |attr, value|
        #     unless (aggregation = reflect_on_aggregation(attr.to_sym)).nil?
        #       mapping = aggregate_mapping(aggregation)
        #       mapping.each do |field_attr, aggregate_attr|
        #         if mapping.size == 1 && !value.respond_to?(aggregate_attr)
        #           expanded_attrs[field_attr] = value
        #         else
        #           expanded_attrs[field_attr] = value.send(aggregate_attr)
        #         end
        #       end
        #     else
        #       expanded_attrs[attr] = value
        #     end
        #   end
        #   expanded_attrs
        # end
        # 
        # # Sanitizes a hash of attribute/value pairs into SQL conditions for a WHERE clause.
        # #   { :name => "foo'bar", :group_id => 4 }
        # #     # => "name='foo''bar' and group_id= 4"
        # #   { :status => nil, :group_id => [1,2,3] }
        # #     # => "status IS NULL and group_id IN (1,2,3)"
        # #   { :age => 13..18 }
        # #     # => "age BETWEEN 13 AND 18"
        # #   { 'other_records.id' => 7 }
        # #     # => "`other_records`.`id` = 7"
        # #   { :other_records => { :id => 7 } }
        # #     # => "`other_records`.`id` = 7"
        # # And for value objects on a composed_of relationship:
        # #   { :address => Address.new("123 abc st.", "chicago") }
        # #     # => "address_street='123 abc st.' and address_city='chicago'"
        # def sanitize_sql_hash_for_conditions(attrs, table_name = quoted_table_name)
        #   attrs = expand_hash_conditions_for_aggregates(attrs)
        # 
        #   conditions = attrs.map do |attr, value|
        #     unless value.is_a?(Hash)
        #       attr = attr.to_s
        # 
        #       # Extract table name from qualified attribute names.
        #       if attr.include?('.')
        #         table_name, attr = attr.split('.', 2)
        #         table_name = connection.quote_table_name(table_name)
        #       end
        # 
        #       attribute_condition("#{table_name}.#{connection.quote_column_name(attr)}", value)
        #     else
        #       sanitize_sql_hash_for_conditions(value, connection.quote_table_name(attr.to_s))
        #     end
        #   end.join(' AND ')
        # 
        #   replace_bind_variables(conditions, expand_range_bind_variables(attrs.values))
        # end
        # alias_method :sanitize_sql_hash, :sanitize_sql_hash_for_conditions
        # 
        # # Sanitizes a hash of attribute/value pairs into SQL conditions for a SET clause.
        # #   { :status => nil, :group_id => 1 }
        # #     # => "status = NULL , group_id = 1"
        # def sanitize_sql_hash_for_assignment(attrs)
        #   attrs.map do |attr, value|
        #     "#{connection.quote_column_name(attr)} = #{quote_bound_value(value)}"
        #   end.join(', ')
        # end
        # 
        # # Accepts an array of conditions.  The array has each value
        # # sanitized and interpolated into the SQL statement.
        # #   ["name='%s' and group_id='%s'", "foo'bar", 4]  returns  "name='foo''bar' and group_id='4'"
        # def sanitize_sql_array(ary)
        #   statement, *values = ary
        #   if values.first.is_a?(Hash) and statement =~ /:\w+/
        #     replace_named_bind_variables(statement, values.first)
        #   elsif statement.include?('?')
        #     replace_bind_variables(statement, values)
        #   else
        #     statement % values.collect { |value| connection.quote_string(value.to_s) }
        #   end
        # end
        # 
        # alias_method :sanitize_conditions, :sanitize_sql
        # 
        # def replace_bind_variables(statement, values) #:nodoc:
        #   raise_if_bind_arity_mismatch(statement, statement.count('?'), values.size)
        #   bound = values.dup
        #   statement.gsub('?') { quote_bound_value(bound.shift) }
        # end
        # 
        # def replace_named_bind_variables(statement, bind_vars) #:nodoc:
        #   statement.gsub(/(:?):([a-zA-Z]\w*)/) do
        #     if $1 == ':' # skip postgresql casts
        #       $& # return the whole match
        #     elsif bind_vars.include?(match = $2.to_sym)
        #       quote_bound_value(bind_vars[match])
        #     else
        #       raise PreparedStatementInvalid, "missing value for :#{match} in #{statement}"
        #     end
        #   end
        # end
        # 
        # def expand_range_bind_variables(bind_vars) #:nodoc:
        #   expanded = []
        # 
        #   bind_vars.each do |var|
        #     next if var.is_a?(Hash)
        # 
        #     if var.is_a?(Range)
        #       expanded << var.first
        #       expanded << var.last
        #     else
        #       expanded << var
        #     end
        #   end
        # 
        #   expanded
        # end
        # 
        # def quote_bound_value(value) #:nodoc:
        #   if value.respond_to?(:map) && !value.acts_like?(:string)
        #     if value.respond_to?(:empty?) && value.empty?
        #       connection.quote(nil)
        #     else
        #       value.map { |v| connection.quote(v) }.join(',')
        #     end
        #   else
        #     connection.quote(value)
        #   end
        # end
        # 
        # def raise_if_bind_arity_mismatch(statement, expected, provided) #:nodoc:
        #   unless expected == provided
        #     raise PreparedStatementInvalid, "wrong number of bind variables (#{provided} for #{expected}) in: #{statement}"
        #   end
        # end
        # 
        # VALID_FIND_OPTIONS = [ :conditions, :include, :joins, :limit, :offset,
        #                        :order, :select, :readonly, :group, :having, :from, :lock ]
        # 
        # def validate_find_options(options) #:nodoc:
        #   options.assert_valid_keys(VALID_FIND_OPTIONS)
        # end
        # 
        # def set_readonly_option!(options) #:nodoc:
        #   # Inherit :readonly from finder scope if set.  Otherwise,
        #   # if :joins is not blank then :readonly defaults to true.
        #   unless options.has_key?(:readonly)
        #     if scoped_readonly = scope(:find, :readonly)
        #       options[:readonly] = scoped_readonly
        #     elsif !options[:joins].blank? && !options[:select]
        #       options[:readonly] = true
        #     end
        #   end
        # end
        # 
        # def encode_quoted_value(value) #:nodoc:
        #   quoted_value = connection.quote(value)
        #   quoted_value = "'#{quoted_value[1..-2].gsub(/\'/, "\\\\'")}'" if quoted_value.include?("\\\'") # (for ruby mode) "
        #   quoted_value
        # end
