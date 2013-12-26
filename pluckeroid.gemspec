lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pluckeroid/version'

Gem::Specification.new do |spec|
  spec.name          = 'pluckeroid'
  spec.version       = Pluckeroid::VERSION
  spec.authors       = ['Dimko']
  spec.email         = ['deemox@gmail.com']
  spec.description   = %q{Pluck for ActiveRecord on steroids}
  spec.summary       = %q{Pluck for ActiveRecord on steroids}
  spec.homepage      = 'https://github.com/dimko/pluckeroid'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 3.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'sqlite3', '~> 1.3.7'
  spec.add_development_dependency 'rspec',   '~> 2.6'
  spec.add_development_dependency 'rake'
end
