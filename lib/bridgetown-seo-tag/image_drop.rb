# frozen_string_literal: true

module Bridgetown
  class SeoTag
    # A drop representing the page image
    # The image path will be pulled from:
    #
    # 1. The `image` key if it's a string
    # 2. The `image.path` key if it's a hash
    # 3. The `image.facebook` key
    # 4. The `image.twitter` key
    class ImageDrop < Bridgetown::Drops::Drop
      include Bridgetown::SeoTag::UrlHelper

      # Initialize a new ImageDrop
      #
      # page - The page hash (e.g., Page#to_liquid)
      # context - the Liquid::Context
      def initialize(page: nil, context: nil)
        raise ArgumentError unless page && context

        @mutations = {}
        @page = page
        @context = context
      end

      # Called path for backwards compatability, this is really
      # the escaped, absolute URL representing the page's image
      # Returns nil if no image path can be determined
      def path
        @path ||= filters.uri_escape(absolute_url) if absolute_url
      end
      alias_method :to_s, :path

      private

      attr_accessor :page, :context

      # The normalized image hash with a `path` key (which may be nil)
      def image_hash
        @image_hash ||= case page["image"]
                        when Hash
                          { "path" => nil }.merge(page["image"])
                        when String
                          { "path" => page["image"] }
                        else
                          { "path" => nil }
                        end
      end
      alias_method :fallback_data, :image_hash

      def raw_path
        @raw_path ||= image_hash["path"] || image_hash["facebook"] || image_hash["twitter"]
      end

      def absolute_url
        return unless raw_path
        return @absolute_url if defined? @absolute_url

        @absolute_url = if raw_path.is_a?(String) && absolute_url?(raw_path) == false
                          filters.absolute_url raw_path
                        else
                          raw_path
                        end
      end

      def filters
        @filters ||= Bridgetown::SeoTag::Filters.new(context)
      end
    end
  end
end
