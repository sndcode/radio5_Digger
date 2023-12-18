# frozen_string_literal: true

require_relative "lib/radio5/version"

Gem::Specification.new do |spec|
  spec.name = "radio5"
  spec.version = Radio5::VERSION
  spec.authors = ["Dmytro Horoshko"]
  spec.email = ["electric.molfar@gmail.com"]

  spec.summary = "(desc)"
  spec.description = "(desc)"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 2.7.0"

  spec.files = Dir.glob("lib/**/*") + %w[README.md CHANGELOG.md LICENSE]
  spec.require_paths = ["lib"]
end
