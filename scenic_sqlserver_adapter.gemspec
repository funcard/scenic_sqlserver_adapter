lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "scenic_sqlserver_adapter/version"

Gem::Specification.new do |spec|
  spec.name          = "scenic_sqlserver_adapter"
  spec.version       = ScenicSqlserverAdapter::VERSION
  spec.authors       = ["Ben Forrest"]
  spec.email         = ["ben@clickmechanic.com"]

  spec.summary       = "SQL Server adapter for Thoughtbot's Scenic gem"
  spec.homepage      = "https://github.com/ClickMechanic/scenic_sqlserver_adapter"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_dependency "scenic", "1.8"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "activerecord-sqlserver-adapter"
end
