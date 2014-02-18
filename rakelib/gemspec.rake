require 'rubygems/package_task'
require './lib/dudley/version'

if ! defined?(Gem)
  puts "Package Target requires RubyGEMs"
else
  PKG_FILES = FileList[
    '[A-Z]*',
    'lib/*.rb',
    'lib/**/*.rb',
    'rakelib/**/*',
    'test/**/*.rb',
    'spec/**/*.rb',
    'examples/**/*',
    'doc/**/*',
  ]
  PKG_FILES.exclude('TAGS')

  DUDLEY_SPEC = Gem::Specification.new do |s|
    s.name = 'dudley'
    s.version = Dudley::VERSION
    s.summary = "Techniques for decoupling from Rails or other frameworks."
    s.description = <<EOF
Dudley is a set of techniques and code practices to aid in the decoupling
of application logic from a framework (Rails in particular, but really any
overly invasive framework).
EOF
    s.files = PKG_FILES.to_a
    s.require_path = 'lib'                         # Use these for libraries.
    s.rdoc_options = [
      '--line-numbers', '--inline-source',
      '--main' , 'doc/main.rdoc',
      '--title', 'Dudley - Rescued from Rails'
    ]

    s.required_ruby_version = '>= 1.9.2'
    s.license = "MIT"

    s.author = "Jim Weirich"
    s.email = "jim.weirich@gmail.com"
    s.homepage = "http://github.com/jimweirich/dudley"
    s.rubyforge_project = "n/a"
  end


  Gem::PackageTask.new(DUDLEY_SPEC) do |pkg|
    pkg.need_zip = false
    pkg.need_tar = false
  end

  file "dudley.gemspec" => ["rakelib/gemspec.rake"] do |t|
    require 'yaml'
    open(t.name, "w") { |f| f.puts DUDLEY_SPEC.to_yaml }
  end

  desc "Create a stand-alone gemspec"
  task :gemspec => ["dudley.gemspec"]

  desc "Check Filelists"
  task :filelists do
    puts "==============="
    puts "PKG_FILES=#{PKG_FILES.inspect}"
    puts "==============="
  end
end
