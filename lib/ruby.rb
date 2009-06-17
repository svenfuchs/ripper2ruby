Dir[File.dirname(__FILE__) + '/ruby/*.rb'].each do |file| 
  require "ruby/#{File.basename(file)}"
end