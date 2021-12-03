$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "frefnet/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "frefnet"
  s.version     = Frefnet::VERSION
  s.authors     = ["Jake"]
  s.email       = ["jake@webbernet.com.au"]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "6.1.0"
  s.add_dependency "mime-types"

  s.add_development_dependency "pg"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'spring-commands-rspec'
  s.add_development_dependency 'byebug'

  s.test_files = Dir["spec/**/*"]
end
