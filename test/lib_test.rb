require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/lib_test_helper'

LIBS = {
  :self => {
    :path => File.dirname(__FILE__) + '/../'
  },
  :rails => {
    :path => '~/Development/shared/rails/rails',
    :exclude => [],
    :erb => [
      %r(/templates/|environment\.rb)
    ]
  },
  :ruby => {
    :path => '/usr/local/ruby19/lib/ruby/1.9.1',
    :exclude => [
      # 'cgi/html.rb',     # uses stacked heredocs
      # 'tk/namespace.rb', # uses arg_ambiguous
      # 'tktable.rb',      # parse error
      # 'tktreectrl.rb'    # parse error
    ]
  },
  :adva_cms => {
    :path => '~/Development/projects/adva_cms/adva_cms/vendor/adva',
    :exclude => [
      %r(/templates/|environment\.rb)
    ]
  }
}

class BuildTest # < Test::Unit::TestCase
  include TestHelper, LibTestHelper

  def test_library_build(options = {})
    only = options[:only]
    libs = Array(options[:only] || LIBS.keys)

    puts "We're going to parse and rebuild the files from the following libraries: #{libs.join(', ')}."
    puts "We'll report an error if the rebuilt code is not exactly the same as the original source."
    puts "Let's go ..."
    errors = {}

    libs.each do |name|
      puts "\ntesting files for lib: #{name}"

      lib = LIBS[name]
      errors[name] = []
      filenames(File.expand_path(lib[:path])).each do |filename|
        next if excluded?(lib, filename)
        src = read_src(filename, lib)
        # p filename
        begin
          result = build(src, filename).to_ruby(true)
          if src == result
            putc '.'
          else
            errors[name] << filename + "\nresult differs from source:\n#{diff(src, result)}\n" 
            putc 'o'
          end
        rescue RuntimeError => e
          line = e.message
          line = filename + ':' + line unless line.index(filename)
          errors[name] << line + "\n"
          putc e.is_a?(Ripper::RubyBuilder::ParseError) ? 'x' : 'e'
        end
      end
    end

    report(errors)
  end

  def test_tmp_file
    filename = File.dirname(__FILE__) + '/fixtures/tmp.rb'
    src = read_src(filename)
    result = build(src, filename).to_ruby(true) || ''
    puts diff(src, result)
  end

  def test_this
    src = 'a+ a +a'
    result = build(src).to_ruby(true) || ''
    puts diff(src, result)
  end
end

BuildTest.new.test_library_build
# BuildTest.new.test_tmp_file