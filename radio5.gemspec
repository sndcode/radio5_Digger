# frozen_string_literal: true

require_relative "lib/radio5/version"

Gem::Specification.new do |spec|
  spec.name = "radio5"
  spec.version = Radio5::VERSION
  spec.authors = ["Dmytro Horoshko"]
  spec.email = ["electric.molfar@gmail.com"]

  spec.summary = "Adapter for Radiooooo private API"
  spec.description = "Adapter for Radiooooo private API."
  spec.homepage = "https://github.com/ocvit/radio5"
  spec.license = "MIT"
  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/ocvit/radio5/issues",
    "changelog_uri" => "https://github.com/ocvit/radio5/blob/main/CHANGELOG.md",
    "homepage_uri" => "https://github.com/ocvit/radio5",
    "source_code_uri" => "https://github.com/ocvit/radio5"
  }

  spec.files = Dir.glob("lib/**/*") + %w[README.md CHANGELOG.md LICENSE.txt]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7"
end
