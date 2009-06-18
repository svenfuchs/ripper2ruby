module Highlighters
  class Ansi
    COLORS = { :red =>";31", :yellow => ";33", :green => ";32" }
    STYLES = { :bold => ";1", :underline => ";4" }
    
    def initialize(*formats)
      @formats = formats
    end
    
    def highlight(text)
      ansi_format(text, @formats)
    end
  
    def ansi_format(text, formats)
      res = "\e[0"
      if formats.is_a?(Array) || formats.is_a?(Hash)
        COLORS.each { |k,v| res += v if formats.include?(k) }
        STYLES.each { |k,v| res += v if formats.include?(k) }
      elsif formats.is_a?(Symbol)
        COLORS.each { |k,v| res += v if formats == k }
        STYLES.each { |k,v| res += v if formats == k }
      elsif formats.respond_to?(:to_sym)
        COLORS.each { |k,v| res += v if formats.to_sym == k }
        STYLES.each { |k,v| res += v if formats.to_sym == k }
      end
      res += "m" + text.to_s + "\e[0m"
    end
  end
end