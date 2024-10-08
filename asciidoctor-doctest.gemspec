require File.expand_path('lib/asciidoctor/doctest/version', __dir__)

Gem::Specification.new do |s|
  s.name          = 'asciidoctor-doctest'
  s.version       = Asciidoctor::DocTest::VERSION
  s.author        = 'Jakub Jirutka'
  s.email         = 'jakub@jirutka.cz'
  s.homepage      = 'https://github.com/asciidoctor/asciidoctor-doctest'
  s.license       = 'MIT'

  s.summary       = 'Test suite for Asciidoctor backends'
  s.description   = <<-EOS
A tool for end-to-end testing of Asciidoctor backends based on comparing of textual output.
  EOS

  s.files         = Dir['data/**/*', 'lib/**/*', '*.gemspec', 'CHANGELOG*', 'LICENSE*', 'README*']
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.0'

  # runtime
  s.add_dependency 'asciidoctor', '>= 1.5.0', '< 3.0'
  s.add_dependency 'corefines', '~> 1.2'
  s.add_dependency 'diffy', '~> 3.0'
  s.add_dependency 'htmlbeautifier', '~> 1.0'
  s.add_dependency 'minitest', '~> 5.25'
  s.add_dependency 'nokogiri', '~> 1.13'

  # development
  s.add_development_dependency 'bundler', '>= 1.6'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rubocop', '~> 1.66'
  s.add_development_dependency 'rubocop-minitest', '~> 0.36'
  s.add_development_dependency 'rubocop-rake', '~> 0.6'
  s.add_development_dependency 'rubocop-rspec', '~> 3.0'
  s.add_development_dependency 'thread_safe', '~> 0.3'

  # unit tests
  s.add_development_dependency 'fakefs', '~> 2.5'
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'rspec-collection_matchers', '~> 1.1'

  # integration tests
  s.add_development_dependency 'aruba', '~> 2.0'
  s.add_development_dependency 'cucumber', '~> 9.0'
  s.add_development_dependency 'slim', '~> 5.0'
  s.metadata['rubygems_mfa_required'] = 'true'
end
