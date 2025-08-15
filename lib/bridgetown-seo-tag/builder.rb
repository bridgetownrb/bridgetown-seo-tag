# frozen_string_literal: true

module Bridgetown
  module SeoTag
    class Builder < Bridgetown::Builder
      def build
        helper "seo" do |title: true|
          context = Liquid::Context.new({}, {}, { site: site, page: helpers.view.page })
          tag_output = Liquid::Template.parse(
            "{% seo #{"title=false" unless title} %}"
          ).render!(context, {})
          tag_output.respond_to?(:html_safe) ? tag_output.html_safe : tag_output
        end
      end
    end
  end
end
