# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'opencomponents/rails/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'rails',   '~> 4.1', '< 5.0.0.alpha'
  spec.add_development_dependency 'bundler', '~> 1.10'

  spec.authors       = ['Todd Bealmear']
  spec.description   = %q{Renders OpenComponents in your Rails views.}
  spec.email         = ['tbealmear@opentable.com']
  spec.files         = %w(LICENSE README.md oc-rails.gemspec)
  spec.files        += Dir.glob('lib/**/*.rb')
  spec.files        += Dir.glob('spec/**/*')
  spec.homepage      = 'https://github.com/opentable/oc-rails'
  spec.licenses      = ['MIT']
  spec.name          = 'rails-oc'
  spec.require_paths = ['lib']
  spec.summary       = spec.description
  spec.version       = OpenComponents::Rails::VERSION
end
