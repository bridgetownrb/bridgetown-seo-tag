# frozen_string_literal: true

module Bridgetown
  class SeoTag
    class Drop < Bridgetown::Drops::Drop
      include Bridgetown::SeoTag::UrlHelper

      TITLE_SEPARATOR = " | "
      TAGLINE_SEPARATOR = ": "
      FORMAT_STRING_METHODS = [
        :markdownify, :strip_html, :normalize_whitespace, :escape_once,
      ].freeze
      HOMEPAGE_OR_ABOUT_REGEX = %r!^/(about/)?(index.html?)?$!.freeze

      def initialize(text, context)
        @obj = {}
        @mutations = {}
        @text = text
        @context = context
      end

      def version
        Bridgetown::SeoTag::VERSION
      end

      # Should the `<title>` tag be generated for this page?
      def title?
        return false unless title
        return @display_title if defined?(@display_title)

        @display_title = (@text !~ %r!title=false!i)
      end

      def site_title
        @site_title ||= format_string(
          site.data.dig("site_metadata", "title") ||
          site.data.dig("site_metadata", "name")
        )
      end

      def site_tagline
        @site_tagline ||= format_string site.data.dig("site_metadata", "tagline")
      end

      def site_description
        @site_description ||= format_string site.data.dig("site_metadata", "description")
      end

      # Page title without site title or description appended
      def page_title
        @page_title ||= format_string(
          if (page["title"] == "Index" || page["title"].blank?) &&
              site_tagline_or_description
            "#{site_title}#{TAGLINE_SEPARATOR}#{site_tagline_or_description}"
          else
            page["title"]
          end
        ) || site_title
      end

      def site_tagline_or_description
        site_tagline || site_description
      end

      # Page title with site title or description appended
      def title
        @title ||= if site_title && page_title != site_title &&
            !format_string(page_title).start_with?(site_title + TAGLINE_SEPARATOR)
                     page_title + TITLE_SEPARATOR + site_title
                   else
                     page_title || site_title
                   end

        @title
      end

      def name
        return @name if defined?(@name)

        @name = if seo_name
                  seo_name
                elsif !homepage_or_about?
                  nil
                elsif site_social["name"]
                  format_string site_social["name"]
                elsif site_title
                  site_title
                end
      end

      def description
        @description ||= format_string(
          page["description"] || page["subtitle"] || page["excerpt"]
        ) || site_description
      end

      # A drop representing the page author
      def author
        @author ||= AuthorDrop.new(page: page, site: site)
      end

      # Returns a Drop representing the page's image
      # Returns nil if the image has no path, to preserve backwards compatability
      def image
        @image ||= ImageDrop.new(page: page, context: @context)
        @image if @image.path
      end

      def date_modified
        @date_modified ||= begin
          date = if page_seo["date_modified"]
                   page_seo["date_modified"]
                 elsif page["last_modified_at"]
                   page["last_modified_at"].to_liquid
                 else
                   page["date"]
                 end
          filters.date_to_xmlschema(date) if date
        end
      end

      def date_published
        @date_published ||= filters.date_to_xmlschema(page["date"]) if page["date"]
      end

      def type
        @type ||= if page_seo["type"]
                    page_seo["type"]
                  elsif homepage_or_about?
                    "WebSite"
                  elsif page["date"]
                    "BlogPosting"
                  else
                    "WebPage"
                  end
      end

      def links
        @links ||= if page_seo["links"]
                     page_seo["links"]
                   elsif homepage_or_about? && site_social["links"]
                     site_social["links"]
                   end
      end

      def logo
        @logo ||= if !site.data.dig("site_metadata", "logo")
                    nil
                  elsif absolute_url? site.data.dig("site_metadata", "logo")
                    filters.uri_escape site.data.dig("site_metadata", "logo")
                  else
                    filters.uri_escape filters.absolute_url site.data.dig("site_metadata", "logo")
                  end
      end

      def page_lang
        @page_lang ||= page["lang"] || site["lang"] || "en_US"
      end

      def canonical_url
        @canonical_url ||= if page["canonical_url"].to_s.present?
                             page["canonical_url"]
                           elsif page["url"].to_s.present?
                             filters.absolute_url(page["url"]).to_s.gsub(%r!/index\.html$!, "/")
                           else
                             filters.absolute_url(page["relative_url"]).to_s.gsub(
                               %r!/index\.html$!, "/"
                             )
                           end
      end

      private

      def filters
        @filters ||= Bridgetown::SeoTag::Filters.new(@context)
      end

      def page
        @page ||= @context.registers[:page].to_liquid
      end

      def site
        @site ||= @context.registers[:site].site_payload["site"].to_liquid
      end

      def homepage_or_about?
        page["url"] =~ HOMEPAGE_OR_ABOUT_REGEX
      end

      attr_reader :context

      def fallback_data
        @fallback_data ||= {}
      end

      def format_string(string)
        string = FORMAT_STRING_METHODS.reduce(string) do |memo, method|
          filters.public_send(method, memo)
        end

        string unless string.empty?
      end

      def seo_name
        @seo_name ||= format_string(page_seo["name"]) if page_seo["name"]
      end

      def page_seo
        @page_seo ||= sub_hash(page, "seo")
      end

      def site_social
        @site_social ||= sub_hash(site.data["site_metadata"], "social")
      end

      # Safely returns a sub hash
      #
      # hash - the parent hash
      # key  - the key in the parent hash
      #
      # Returns the sub hash or an empty hash, if it does not exist
      def sub_hash(hash, key)
        if hash && hash[key].is_a?(Hash)
          hash[key]
        else
          {}
        end
      end
    end
  end
end
