# frozen_string_literal: true

RSpec.describe Bridgetown::SeoTag::MastodonDrop do
  let(:data) { {} }
  let(:site_config) { {} }
  let(:metadata_config) { { "mastodon" => "@handle@metadata.config" } }
  let(:site) do
    site = make_site(metadata_config, site_config)
    site.data = site.data.merge(data)
    site
  end
  let(:site_payload) { site.site_payload["site"] }

  let(:page_meta) { { "title" => "page title" } }
  let(:page)      { make_page(page_meta) }
  subject { described_class.new(page: page.to_liquid, site: site_payload.to_liquid) }

  before do
    Bridgetown.logger.log_level = :error
  end

  it "returns the mastodon handle for #to_s" do
    expect(subject.to_s).to eql("@handle@metadata.config")
  end

  context "with mastodon handle in site metadata" do
    it "returns the site metadata handle" do
      expect(subject.mastodon_handle).to eql("@handle@metadata.config")
    end
  end

  context "with mastodon handle in front matter default" do
    let(:site_config) do
      {
        "defaults" => [
          {
            "scope"  => { "path" => "" },
            "values" => { "mastodon" => "@handle@frontmatter.defaults" },
          },
        ],
      }
    end

    it "uses the handle from the front matter default" do
      site # init new config
      defaults_page = Bridgetown::SeoTag::MastodonDrop.new(page: make_resource_page.to_liquid, site: site_payload.to_liquid)
      expect(defaults_page["mastodon"]).to eql("@handle@frontmatter.defaults")
    end
  end

  context "with mastodon override in page meta" do
    let(:page_meta) { { "mastodon" => "@handle@page.meta" } }

    it "uses the value defined in page metadata" do
      expect(subject["mastodon"]).to eql("@handle@page.meta")
    end

    context "with an empty value" do
      let(:metadata_config) { {} }
      let(:page_meta) { { "mastodon" => "" } }

      it "doesn't blow up" do
        expect(subject["mastodon"]).to be_nil
      end
    end

    context "with a hash value" do
      let(:page_meta) { { "mastodon" => { "some" => "thing" } } }

      it "doesn't blow up" do
        expect(subject["mastodon"]).to be_nil
      end
    end

    context "with an array value" do
      let(:page_meta) { { "mastodon" => [] } }

      it "doesn't blow up" do
        expect(subject["mastodon"]).to be_nil
      end
    end
  end
end
