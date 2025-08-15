# frozen_string_literal: true

module Bridgetown
  module SeoTag
    # A drop representing the current page's mastodon handle
    #
    # Mastodon handle will be pulled from:
    #
    # 1. The page's `mastodon` key
    # 2. The `mastodon` key in the site config
    class MastodonDrop < Bridgetown::Drops::Drop
      HANDLE_REGEX = %r{\A@?(?<username>[^@]+)@(?<server>[^@]+)\z}

      # Initialize a new MastodonDrop
      #
      # page - The page hash (e.g., Page#to_liquid)
      # site - The Bridgetown::Drops::SiteDrop
      def initialize(page: nil, site: nil)
        raise ArgumentError unless page && site

        @mutations = {}
        @page = page
        @site = site
      end

      def mastodon_handle
        "@#{username}@#{server}" if handle?
      end
      alias_method :to_s, :mastodon_handle

      def mastodon_url
        "https://#{server}/@#{username}" if handle?
      end

      # Make the drop behave like a hash
      def [](key)
        mastodon_handle if key.to_sym == :mastodon
      end

      private

      attr_reader :page, :site

      # Finds the mastodon handle in page.metadata, or site.metadata
      #
      # Returns a string
      def resolved_handle
        return @resolved_handle if defined? @resolved_handle

        sources = [page["mastodon"]]
        sources << site.data.dig("site_metadata", "mastodon")
        @resolved_handle = sources.find { |s| !s.to_s.empty? }
      end

      # Returns the username parsed from the resolved handle
      def username
        handle_hash["username"]
      end

      # Returns the server parsed from the resolved handle
      def server
        handle_hash["server"]
      end

      # Returns a hash containing username and server
      # or an empty hash, if the handle cannot be parsed
      def handle_hash
        @handle_hash ||= case resolved_handle
                         when String
                           HANDLE_REGEX.match(resolved_handle)&.named_captures || {}
                         else
                           {}
                         end
      end
      # Since author_hash is aliased to fallback_data, any values in the hash
      # will be exposed via the drop, allowing support for arbitrary metadata
      alias_method :fallback_data, :handle_hash

      def handle?
        handle_hash != {}
      end
    end
  end
end
