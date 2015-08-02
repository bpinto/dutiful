$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'dutiful/version'

Gem::Specification.new do |s|
  s.name        = 'dutiful'
  s.version     = Dutiful::VERSION
  s.license     = 'MIT'
  s.authors     = ['Bruno Pinto']
  s.email       = 'brunoferreirapinto@gmail.com'
  s.homepage    = 'http://github.com/bpinto/dutiful'
  s.summary     = "dutiful-#{Dutiful::VERSION}"
  s.description = 'Dotfiles manager'

  s.files        = `git ls-files -- lib/* config/* db/*`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path = "lib"

  s.add_runtime_dependency 'clamp', '~> 1.0'
  s.add_runtime_dependency 'colorize', '~> 0.7'
  s.add_runtime_dependency 'rsync', '~> 1.0'
  s.add_runtime_dependency 'tomlrb', '~> 1.1'

  s.add_development_dependency 'fakefs', '~> 0.6'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.3'
end
