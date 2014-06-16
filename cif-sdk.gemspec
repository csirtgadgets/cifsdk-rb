Gem::Specification.new do |s|
  s.name               = "cif.sdk"
  s.version            = "0.0.1"
  s.default_executable = "cif"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Wes Young"]
  s.date = %q{2014-06-16}
  s.description = %q{Ruby SDK for CIF}
  s.email = %q{wes@barely3am.com}
  s.files = ["Rakefile", "lib/cif/sdk.rb", "bin/cif"]
  s.test_files = ["test/test_cif.rb"]
  s.homepage = %q{http://rubygems.org/gems/cif.sdk}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{2.1}
  s.summary = %q{Ruby SDK for CIF!}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end