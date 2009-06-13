require 'ansi'

Dir[File.dirname(__FILE__) + '/ruby/*.rb'].each do |file| 
  require "ruby/#{File.basename(file)}"
end

module Ruby
  @@context_width = 2

  class << self
    def context_width
      @@context_width
    end

    def context_width=(num)
      @@context_width = num
    end
  end
end