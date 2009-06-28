require 'ripper'
require 'highlighters/ansi'

class Ripper
  class EventLog < Ripper::SexpBuilder
    class << self
      def out(src)
        parser = new(src)
        parser.parse
        parser.out
      end
    end
  
    attr_reader :log
  
    def initialize(src)
      @log = []
      super
    end
    
    def out
      log.each do |type, sexp|
        arg = sexp[1] =~ /\s/ ? sexp[1].inspect : sexp[1]
        line = (sexp[0].to_s).ljust(20)
        if type == :scanner
          puts line + arg[0..30] 
        else
          puts highlight(line)
        end
      end
    end
  
    def highlight(str)
      Highlighters::Ansi.new(:bold, :green).highlight(str)
    end
  
    { :scanner => SCANNER_EVENTS, :parser => PARSER_EVENTS }.each do |type, events|
      events.each do |event|
        define_method :"on_#{event}" do |*args|
          log << [type, super(*args)]
        end
      end
    end
  end
end