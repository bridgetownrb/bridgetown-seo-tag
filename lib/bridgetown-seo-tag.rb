# frozen_string_literal: true

require "bridgetown"
require "bridgetown-seo-tag/version"

module Bridgetown::SeoTag
  autoload :AuthorDrop, "bridgetown-seo-tag/author_drop"
  autoload :MastodonDrop, "bridgetown-seo-tag/mastodon_drop"
  autoload :ImageDrop,  "bridgetown-seo-tag/image_drop"
  autoload :UrlHelper,  "bridgetown-seo-tag/url_helper"
  autoload :Drop,       "bridgetown-seo-tag/drop"
  autoload :Filters,    "bridgetown-seo-tag/filters"
end

class Bridgetown::SeoTag::LiquidTag < Liquid::Tag
  attr_accessor :context

  # Matches all whitespace that follows either
  #   1. A '}', which closes a Liquid tag
  #   2. A '{', which opens a JSON block
  #   3. A '>' followed by a newline, which closes an XML tag or
  #   4. A ',' followed by a newline, which ends a JSON line
  # We will strip all of this whitespace to minify the template
  # We will not strip any whitespace if the next character is a '-'
  #   so that we do not interfere with the HTML comment at the
  #   very begining
  MINIFY_REGEX = %r!(?<=[{}]|[>,]\n)\s+(?\!-)!

  def initialize(_tag_name, text, _tokens)
    super
    @text = text
  end

  def render(context)
    @context = context
    self.class.template.render!(payload, info)
  end

  private

  def options
    {
      "version" => Bridgetown::SeoTag::VERSION,
      "title"   => title?,
    }
  end

  def payload
    if context.registers[:page].respond_to?(:paginator)
      paginator = context.registers[:page].paginator
    end

    # site_payload is an instance of UnifiedPayloadDrop
    Bridgetown::Utils.deep_merge_hashes(
      context.registers[:site].site_payload,
      "page"      => context.registers[:page],
      "paginator" => paginator,
      "seo_tag"   => drop
    )
  end

  def drop
    if context.registers[:site].liquid_renderer.respond_to?(:cache)
      Bridgetown::SeoTag::Drop.new(@text, context)
    else
      @drop ||= Bridgetown::SeoTag::Drop.new(@text, context)
    end
  end

  def info
    {
      registers: {
        site: context.registers[:site],
        page: context.registers[:page],
      },
      filters: [Bridgetown::Filters],
    }
  end

  class << self
    def template
      @template ||= Liquid::Template.parse template_contents
    end

    private

    def template_contents
      @template_contents ||= File.read(template_path).gsub(MINIFY_REGEX, "")
    end

    def template_path
      @template_path ||= File.expand_path "./template.html", File.dirname(__FILE__)
    end
  end
end

Liquid::Template.register_tag("seo", Bridgetown::SeoTag::LiquidTag)
require "bridgetown-seo-tag/builder"

Bridgetown.initializer :"bridgetown-seo-tag" do |config|
  config.builder Bridgetown::SeoTag::Builder
end
