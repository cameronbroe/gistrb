lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gist/version'

Gem::Specification.new do |spec|
  spec.name          = 'gistrb'
  spec.version       = Gist::VERSION
  spec.authors       = ['Cameron Roe']
  spec.email         = ['cameron@cameronbroe.com']
  spec.licenses      = ['MIT']

  spec.summary       = 'A command-line utility to manage GitHub Gists'
  spec.homepage      = 'https://github.com/cameronbroe/gistrb'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rubocop', '~> 0.51'
  spec.add_dependency 'clipboard', '~> 1.1'
  spec.add_dependency 'ffi', '~> 1.9.18' if RUBY_PLATFORM =~ /win32/i
  spec.add_dependency 'highline', '~> 1.7'
end
