# frozen_string_literal: true

module Bridgetown
  class SeoTag
    # Mixin to share common URL-related methods between class
    module UrlHelper
      private

      # Determines if the given string is an absolute URL
      #
      # Returns true if an absolute URL.
      # Retruns false if it's a relative URL
      # Returns nil if it is not a string or can't be parsed as a URL
      def absolute_url?(string)
        return false unless string

        Addressable::URI.parse(string).absolute?
      rescue Addressable::URI::InvalidURIError
        nil
      end
    end
  end
end
