require 'ruby/node'

module Ruby
  class Keyword < Identifier
    @@keywords = {
      'true'     => true,
      'false'    => false,
      'nil'      => nil,
      # 'and'      => 'and',
      # 'or'       => 'or',
      # 'not'      => 'not',
      # 'class'    => 'class',
      # 'module'   => 'module',
      # 'def'      => 'def',
      # 'do'       => 'do',
      # 'end'      => 'end',
      # 'if'       => 'if',
      # 'elsif'    => 'elsif',
      # 'else'     => 'else',
      # 'self'     => 'self',
      # '__FILE__' => '__FILE__',
      # '__LINE__' => '__LINE__'
    }
    
    def value
      @@keywords.has_key?(token) ? @@keywords[token] : token
    end
  end
end