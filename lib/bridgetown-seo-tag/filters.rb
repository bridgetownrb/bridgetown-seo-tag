# frozen_string_literal: true

module Bridgetown
  class SeoTag
    class Filters
      include Bridgetown::Filters
      include Liquid::StandardFilters

      def initialize(context)
        @context = context
      end
    end
  end
end
