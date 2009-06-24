files = Dir[File.dirname(__FILE__) + '/**/*_test.rb']
files.reject! { |f| f.index('lib_test.rb') }
files.each { |file| require file }