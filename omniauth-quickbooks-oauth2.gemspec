# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-quickbooks-oauth2/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-quickbooks-oauth2'
  spec.version       = OmniAuth::QuickbooksOauth2::VERSION
  spec.authors       = ['Abe Land', 'Amoniac Team']
  spec.email         = ['codeclimbcoffee@gmail.com', 'team-bb@amoniac.eu']

  spec.summary       = 'OAuth2 Omniauth strategy for Quickbooks.'
  spec.description   = 'OAuth2 Omniauth straetgy for Quickbooks (Intuit) API.'
  spec.homepage      = 'https://github.com/abeland/omniauth-quickbooks-oauth2'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_dependency 'omniauth-oauth2', '>= 1.8'

  spec.add_development_dependency 'bundler', '~> 2.3.7'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake', '~> 13.0.6'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rspec', '~> 3.11.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
  spec.add_development_dependency 'simplecov_json_formatter'
  spec.add_development_dependency 'webmock'
  spec.metadata = { 'github_repo' => 'ssh://github.com/AmoniacBB/omniauth-quickbooks-oauth2' }
end
