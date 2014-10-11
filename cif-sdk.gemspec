lib = File.expand_path('../lib',__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cif-sdk/version'

# http://bundler.io/v1.6/rubygems.html

Gem::Specification.new do |spec|
  spec.name            = "cif-sdk"
  spec.version         = CIF::SDK::VERSION
  spec.authors         = ["Wes Young", "CSIRT Gadgets Foundation"]
  spec.summary         = %q{Ruby SDK for CIF!}
  spec.description     = %q{Ruby SDK for CIF}
  spec.email           = %q{wes@barely3am.com}
  spec.homepage        = %q{https://github.com/csirtgadgets/rb-cif-sdk}
  spec.licenses        = 'LGPL-3'

  spec.files          = `git ls-files -z`.split("\x0")
  spec.executables    = ['cif']
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths  = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 0'

  spec.add_runtime_dependency 'httpclient', '~> 0'
  spec.add_runtime_dependency 'uri', '~> 0'
end
