require_relative 'lib/rely/version'

Gem::Specification.new do |spec|
  spec.name = 'rely'
  spec.version = Rely::VERSION
  spec.authors = ['Tyler Hunt']
  spec.email = %w(tyler@tylerhunt.com)
  spec.summary = 'A small library for simplifying dependency injection.'
  spec.homepage = ''
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
end
