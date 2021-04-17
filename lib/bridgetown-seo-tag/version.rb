# frozen_string_literal: true

# Prevent bundler errors
module Liquid; class Tag; end; end

module Bridgetown
  class SeoTag < Liquid::Tag
    VERSION = "4.0.0"
  end
end
