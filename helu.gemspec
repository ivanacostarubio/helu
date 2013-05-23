# -*- encoding: utf-8 -*-
VERSION = "0.1"

Gem::Specification.new do |spec|
  spec.name          = "helu"
  spec.version       = VERSION
  spec.authors       = ["Ivan Acosta-Rubio"]
  spec.email         = ["ivan@bakedweb.net"]
  spec.description   = %q{RubyMotion :: StoreKit Wrapper :: Allows In App Purchases }
  spec.summary       = %q{RubyMotion StoreKit Wrapper}
  spec.homepage      = "http://www.ivanacostarubio.com"
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
end
