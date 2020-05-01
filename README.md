## About Bridgetown SEO Tag

A Bridgetown plugin to add metadata tags for search engines and social networks to better index and display your site's content.

[![Gem Version](https://badge.fury.io/rb/bridgetown-seo-tag.svg)](https://badge.fury.io/rb/bridgetown-seo-tag)

## Installation

Run this command to add this plugin to your site's Gemfile:

```shell
$ bundle add bridgetown-seo-tag -g bridgetown_plugins
```

Or simply add this line to your Gemfile:

```ruby
gem 'bridgetown-seo-tag', group: "bridgetown_plugins"
```

And then add the Liquid tag to your HTML head:

```liquid
{% seo %}
```

## What it does

Bridgetown SEO Tag adds the following meta tags to your site:

* Page title, with site title or description appended
* Page description
* Canonical URL
* Next and previous URLs on paginated pages
* [Open Graph](https://ogp.me/) title, description, site title, and URL (for Facebook, LinkedIn, etc.)
* [Twitter Summary Card](https://dev.twitter.com/cards/overview) metadata

While you could theoretically add the necessary metadata tags yourself, Bridgetown SEO Tag provides a battle-tested template of crowdsourced best-practices.

**NOTE:** make sure you add your site-wide SEO Tag metadata to `src/_data/site_metadata.yml`, not `bridgetown.config.yml`

## What it doesn't do

Bridgetown SEO tag is designed to output machine-readable metadata for search engines and social networks to index and display. 

Bridgetown SEO tag isn't designed to accommodate every possible use case. It should work for most site out of the box and without a laundry list of configuration options that serve only to confuse most users.

## Documentation

More detailed documentation forthcoming.

## Testing

* Run `bundle exec rspec` to run the test suite
* Or run `script/cibuild` to validate with Rubocop and test with rspec together

## Contributing

1. Fork it (https://github.com/bridgetownrb/bridgetown-seo-tag/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
