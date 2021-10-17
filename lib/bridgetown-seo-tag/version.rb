# frozen_string_literal: true

# Prevent bundler errors
module Liquid; class Tag; end; end # rubocop:disable Lint/EmptyClass

module Bridgetown
  class SeoTag < Liquid::Tag
    VERSION = "5.0.0"
  end
end
