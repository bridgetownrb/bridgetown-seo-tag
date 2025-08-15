# frozen_string_literal: true

module Bridgetown
  module SeoTag
    class Filters
      include Bridgetown::Filters
      include Liquid::StandardFilters

      def initialize(context)
        @context = context
      end
    end
  end
end
