require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/lib_test_helper'

class BuildTest
  include TestHelper, LibTestHelper

  def test_library_build(*libs)
    options = libs.last.is_a?(Hash) ? libs.pop : {}
    verbose = options[:verbose]
    libs = LIBS.keys if libs.empty?

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
        p filename if verbose
        begin
          result = build(src, filename).to_ruby(true)
          if src == result
            putc '.'
          else
            errors[name] << filename + "\nresult differs from source:\n#{diff(src, result)}\n"
            verbose ? puts(diff(src, result)) : putc('o')
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

LIBS = {
  :self => {
    :path => File.dirname(__FILE__) + '/../',
    :exclude => []
  },
  :rails => {
    :path => '~/Development/shared/rails/rails',
    :erb => %r(/templates/|environment\.rb),
    :exclude => []
  },
  :ruby => {
    :path => '/usr/local/ruby19/lib/ruby/1.9.1'
  },
  :parse_tree => {
    :path => '/usr/local/lib/ruby/gems/1.8/gems/ParseTree-3.0.2'
  },
  :capistrano => {
    :path => '/usr/local/lib/ruby/gems/1.8/gems/capistrano-2.5.3'
  },
  :cucumber => {
    :path => '/usr/local/lib/ruby/gems/1.8/gems/cucumber-0.3.11',
    :erb => %r(/templates/|environment\.rb)
  },
  :rack => {
    :path => '/usr/local/lib/ruby/gems/1.8/gems/rack-0.9.1'
  },
  :adva_cms => {
    :path => '~/Development/projects/adva_cms/adva_cms/vendor/adva',
    :erb => %r(/templates/|environment\.rb),
    :exclude => []
  }
}

BuildTest.new.test_library_build #(:parse_tree)
# BuildTest.new.test_tmp_file