lib = File.expand_path('../lib',__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cif-sdk/version'

Gem::Specification.new do |s|
  s.name               = "cif-sdk"
  s.version            = CIF::SDK::VERSION
  s.authors         = ["CSIRT Gadgets Foundation"]
  s.description     = %q{Ruby SDK for CIF}
  s.email           = %q{wes@barely3am.com}
  s.files           = Dir["{bin,spec,lib}/**/*"] + ["Rakefile", "README.md", "Gemfile"]
  s.homepage        = %q{https://github.com/csirtgadgets/rb-cif-sdk}
  s.require_paths   = ["lib"]
  s.summary         = %q{Ruby SDK for CIF!}
  s.executables     = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files      = gem.files.grep(%r{^(test|spec|features)/})

end
