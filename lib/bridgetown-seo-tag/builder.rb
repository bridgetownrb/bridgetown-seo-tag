module Bridgetown
  class SeoTag
    class Builder < Bridgetown::Builder
      def build
        helper "seo", helpers_scope: true do |title: true|
          context = Liquid::Context.new({}, {}, { site: site, page: view.page })
          tag_output = Liquid::Template.parse("{% seo #{"title=false" unless title} %}").render!(context, {})
          tag_output.respond_to?(:html_safe) ? tag_output.html_safe : tag_output
        end
      end
    end
  end
end

Bridgetown::SeoTag::Builder.register
