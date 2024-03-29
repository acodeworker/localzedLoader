# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-localzedLoader/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-localzedLoader'
  spec.version       = CocoapodsLocalzedloader::VERSION
  spec.authors       = ['jeremylu']
  spec.email         = ['1509028992@qq.com']
  spec.description   = %q{A short description of cocoapods-localzedLoader.}
  spec.summary       = %q{A longer description of cocoapods-localzedLoader.}
  spec.homepage      = 'https://github.com/EXAMPLE/cocoapods-localzedLoader'
  spec.license       = 'MIT'

  spec.files = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # spec.add_development_dependency 'bundler'
  # spec.add_development_dependency 'rake'
  spec.add_dependency 'httparty','0.21.0'
  spec.add_dependency 'rubyXL','3.4.12'

end
