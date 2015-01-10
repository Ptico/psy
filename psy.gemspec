lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'psy/version'

Gem::Specification.new do |spec|
  spec.name          = 'psy'
  spec.version       = Psy::VERSION::String
  spec.authors       = ['Andrey Savchenko']
  spec.email         = ['andrey@aejis.eu']
  spec.summary       = %q{Controller layer for your webapps}
  spec.description   = %q{Modular rack controller constructor}
  spec.homepage      = 'https://github.com/Ptico/psy'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.0'
end
