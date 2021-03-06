# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gecko_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'gecko_api'
  spec.version       = GeckoAPI::VERSION
  spec.authors       = ['nolyoi']
  spec.email         = ['nolan@moonship.cc']

  spec.summary       = "Pulling data from CoinGecko's top 100 API and displaying it neatly in your command line."
  spec.description   = "Pulling data from CoinGecko's top 100 API and displaying it neatly in your command line."
  spec.homepage      = 'https://nolanm.dev/'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/nolyoi/GeckoAPI'
    spec.metadata['changelog_uri'] = 'https://github.com/nolyoi/GeckoAPICHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against '
    'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'artii'
  spec.add_development_dependency 'colorize'
  spec.add_development_dependency 'pry', '~> 0.13.1'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'terminal-table'
end
