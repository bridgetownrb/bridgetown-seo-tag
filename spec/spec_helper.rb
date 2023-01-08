# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "bridgetown"

Bridgetown.begin!

# rubocop:disable Lint/Void
Bridgetown::Site # resolve weird autoload issue
# rubocop:enable Lint/Void
require "bridgetown-seo-tag"
require "html-proofer"

# Monkey patch Bridgetown::Drops::Drop so Rspec's `have_key` works as expected
module Bridgetown
  module Drops
    class Drop
      alias_method :has_key?, :key?
    end
  end
end

ENV["BRIDGETOWN_LOG_LEVEL"] = "error"

def root_dir
  File.expand_path("fixtures", __dir__)
end

def source_dir
  File.join(root_dir, "src")
end

def dest_dir
  File.expand_path("../tmp/dest", __dir__)
end

CONFIG_DEFAULTS = {
  "root_dir"    => root_dir,
  "source"      => source_dir,
  "destination" => dest_dir,
}.freeze

def make_page(options = {})
  page = Bridgetown::GeneratedPage.new site, CONFIG_DEFAULTS["source"], "", "page.md"
  page.data = options.with_dot_access
  page
end

def make_resource_page(options = {})
  origin = Bridgetown::Model::RepoOrigin.new_with_collection_path(:pages, "page.md")
  page = Bridgetown::Model::Base.new(origin.read).to_resource
  page.data.merge!(options)
  page
end

def make_post(options = {})
  # filename = File.expand_path("_posts/2015-01-01-post.md", CONFIG_DEFAULTS["source"])
  # config = { site: site, collection: site.collections["posts"] }
  origin = Bridgetown::Model::RepoOrigin.new_with_collection_path(:posts, "_posts/2015-01-01-post.md")
  page = Bridgetown::Model::Base.new(origin.read).to_resource
  #  page = Bridgetown::Resource::Base.new filename, config
  page.data.merge!(options)
  page
end

def make_site(options = {}, site_config = {})
  config = Bridgetown.configuration(CONFIG_DEFAULTS.merge(site_config)).tap do |conf|
    conf.run_initializers! context: :static
  end
  site = Bridgetown::Site.new(config)
  site.data["site_metadata"] = options
  site
end

def make_context(registers = {}, environments = {})
  Liquid::Context.new(environments, {}, { site: site, page: page }.merge(registers))
end
