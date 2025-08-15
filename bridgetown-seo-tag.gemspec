# frozen_string_literal: true

require_relative "lib/bridgetown-seo-tag/version"

Gem::Specification.new do |spec|
  spec.name          = "bridgetown-seo-tag"
  spec.version       = Bridgetown::SeoTag::VERSION
  spec.author        = "Bridgetown Team"
  spec.email         = "maintainers@bridgetownrb.com"
  spec.summary       = "A Bridgetown plugin to add metadata tags for search engines and social networks to better index and display your site's content."
  spec.homepage      = "https://github.com/bridgetownrb/bridgetown-seo-tag"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.1.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|script|spec|features)/!) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bridgetown", ">= 1.3"
  spec.metadata["rubygems_mfa_required"] = "true"
end
