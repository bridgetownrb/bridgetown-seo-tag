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

Or if you wish to control your HTML `<title>` tag yourself:

```liquid
{% seo title=false %}
```

You can use the `seo` helper in Ruby templates as well:

```erb
<%= seo %>
<!-- or -->
<%= seo title: false %>
```

## Summary

Bridgetown SEO Tag adds the following meta tags to your site:

* Page title, with site title or description appended (optional)
* Page description
* Canonical URL
* Next and previous URLs on paginated pages
* [Open Graph](https://ogp.me/) title, description, site title, and URL (for Facebook, LinkedIn, etc.)
* [Twitter Summary Card](https://developer.twitter.com/en/docs/tweets/optimize-with-cards/guides/getting-started) metadata

While you could theoretically add the necessary metadata tags yourself, Bridgetown SEO Tag provides a battle-tested template of crowdsourced best-practices.

**NOTE:** make sure you add your site-wide SEO Tag metadata to `src/_data/site_metadata.yml`, not `bridgetown.config.yml`

## Usage

The SEO tag will use the following configuration options from `bridgetown.config.yml`:

* `url` - The full URL to your site.
* `lang` - The locale for the site, or the current document if specified in the document's front matter. Format `language_TERRITORY` — default is `en_US`.

The SEO tag will respect any of the following if included in your site's `site_metadata.yml` (and simply not include them if they're not defined):

* `title` - Your website's title (e.g., Super-cool Website).
* `tagline` - A short description (e.g., A blog dedicated to reviewing cat gifs), used in instances (like a home page) where there isn't a dedicated document title.
* `description` - A longer description used for the description meta tag. Also used as fallback for documents that don't provide their own `description` and as part of the home page title tag if `tagline` is not defined.
* `author` - global author information (see [Advanced usage](https://github.com/bridgetownrb/bridgetown-seo-tag/wiki/Advanced-Usage#author-information))

* `twitter` - You can add a single Twitter handle to be used in Twitter card tags, like "bridgetownrb". Or you use a YAML mapping with additional details:
  * `twitter:card` - The site's default card type
  * `twitter:username` - The site's Twitter handle

  Example:

  ```yml
  twitter:
    username: benbalter
    card: summary
  ```

* `facebook` - The following properties are available:
  * `facebook:app_id` - a Facebook app ID for Facebook insights
  * `facebook:publisher` - a Facebook page URL or ID of the publishing entity
  * `facebook:admins` - a Facebook user ID for domain insights linked to a personal account

  You'll want to describe one or more like so:

  ```yml
  facebook:
    app_id: 1234
    publisher: 1234
    admins: 1234
  ```

* `google_site_verification` for verifying ownership for Google Search Console
* Alternatively, verify ownership with several services at once using the following format:

```yml
webmaster_verifications:
  google: 1234
  bing: 1234
  alexa: 1234
  yandex: 1234
  baidu: 1234
```

The SEO tag will respect the following YAML front matter if included in a post, page, or document:

* `title` - The title of the document
* `description` - A short description of the document's content
* `image` - URL to an image associated with the document (e.g., `/assets/page-pic.jpg`)
* `author` - Document-specific author information (see [Advanced usage](https://github.com/bridgetownrb/bridgetown-seo-tag/wiki/Advanced-Usage#author-information))
* `lang` - Document-specific language information

*Note:* Front matter defaults can be used for any of the above values.

### Setting a default image

You can define a default image using [Front Matter defaults](https://www.bridgetownrb.com/docs/configuration/front-matter-defaults/) to provide a default Twitter Card or Open Graph image to all of your documents.

Here is a very basic example, that you are encouraged to adapt to your needs:

```yml
defaults:
  - scope:
      path: ""
    values:
      image: /assets/images/default-card.png
```

[More advanced usage information is on the Wiki here.](https://github.com/bridgetownrb/bridgetown-seo-tag/wiki/Advanced-Usage)

## Testing

* Run `bundle exec rspec` to run the test suite
* Or run `script/cibuild` to validate with Rubocop and test with rspec together

## Contributing

1. Fork it (https://github.com/bridgetownrb/bridgetown-seo-tag/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
