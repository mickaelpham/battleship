# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'battleship/version'

Gem::Specification.new do |spec|
  spec.name     = 'battleship'
  spec.version  = Battleship::VERSION
  spec.licenses = ['MIT']
  spec.authors  = ['Mickael Pham']
  spec.email    = ['mickael.pham@gmail.com']

  spec.summary  = 'The classic guessing game for two players.'
  spec.homepage = 'https://github.com/mickaelpham/battleship'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency     'colorize',  '~> 0.8'
  spec.add_development_dependency 'bundler',   '~> 1.15'
  spec.add_development_dependency 'rake',      '~> 10.0'
  spec.add_development_dependency 'rspec',     '~> 3.0'
  spec.add_development_dependency 'fuubar',    '~> 2.2'
  spec.add_development_dependency 'pry',       '~> 0.10'
  spec.add_development_dependency 'rubocop',   '~> 0.49'
  spec.add_development_dependency 'reek',      '~> 4.7'
  spec.add_development_dependency 'simplecov', '~> 0.15'
end
