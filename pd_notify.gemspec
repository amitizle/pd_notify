# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pd_notify/version"

Gem::Specification.new do |spec|
  spec.name          = "pd_notify"
  spec.version       = PdNotify::VERSION
  spec.authors       = ["Amit Goldberg"]
  spec.email         = ["amit.goldberg@gmail.com"]

  spec.summary       = %q{MacOS Desktop alerts for Pagerduty}
  spec.description   = %q{MacOS Desktop alerts for Pagerduty}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  not_included_dirs = ['spec', 'test', 'features']
  not_included_regex = Regexp.new("\.#{File::SEPARATOR}(#{not_included_dirs.join('|')})(#{File::SEPARATOR}.*|$)")
  spec.files = Dir.glob(File.join(__dir__, '**', '*')).reject do |f|
    f.match?(not_included_regex)
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(/\.#{File::SEPARATOR}exe#{File::SEPARATOR}/) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client', '~> 2.0'
  spec.add_dependency 'terminal-notifier', '~> 1.8'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
