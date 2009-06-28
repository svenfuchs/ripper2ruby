# replaces html and erb tags with whitespace so that we can parse the result
# as pure ruby preserving the exact positions of tokens in the original erb
# source code

require 'erb'
$KCODE = 'u' if RUBY_VERSION < '1.9'

module Erb
  class Scanner < ERB::Compiler::Scanner
    def scan
      stag_reg = /(.*?)(^[ \t]*<%%|<%%=|<%=|<%#|<%-|<%|\z)/m
      etag_reg = /(.*?)(%%>|\-%>|%>|\z)/m
      scanner = StringScanner.new(@src)
      while !scanner.eos?
        scanner.scan(@stag ? etag_reg : stag_reg)
        yield(scanner[1]) unless scanner[1].nil?
        yield(scanner[2]) unless scanner[2].nil?
      end
    end
  end
  ERB::Compiler::Scanner.regist_scanner(Scanner, nil, false)

  class Stripper
    def to_ruby(source)
      result = ''
      comment = false
      scanner = ERB::Compiler.new(nil).make_scanner(source)
      scanner.scan do |token|
        comment = true if token == '<%#'
        if scanner.stag.nil?
          result << to_whitespace(token)
          scanner.stag = token if ['<%', '<%%', '<%-', '<%=', '<%%=', '<%#'].include?(token.strip)
        elsif ['%>', '%%>', '-%>'].include?(token.strip)
          result << to_whitespace(token.gsub(/>/, ';'))
          scanner.stag = nil
        else
          result << (comment ? to_whitespace(token) : token)
          comment = false
        end
      end
      result
    end
  
    def to_whitespace(str)
      str.gsub(/[^\s;]/, ' ')
    end
  end
end