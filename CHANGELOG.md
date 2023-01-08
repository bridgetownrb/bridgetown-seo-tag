# Changelog

## 6.0.0 / 2023-01-08

- Fix bug where prev/next rel links for paginated pages were missing
- Upgrade to initializers system in Bridgetown 1.2
- Add support for image alt metadata
- Add fallback for og:type metadata 

## 5.0.0 / 2021-10-17

- Change "Site Title | Site Tagline" format to "Site Title: Site Tagline"
  - also handle Bridgetown 1.0 templates where the homepage title defaults to `Index`
  - upgrade rubocop-bridgetown gem to 0.3

## 4.0.1 / 2021-06-04

- Fix bug where resources' relative URLs weren't included properly

## 4.0.0 / 2021-04-17

- New release with helper to support Ruby templates like ERB

## 3.0.5  / 2020-06-18

- Final release

## 3.0.5.beta1 / 2020-05-31

- Fix bugs due to Bridgetown 0.15 switch to `render` tag.
- Switch to using Rubocop Bridgetown gem.

## 3.0.4 / 2020-05-01

- Update to require a minimum Ruby version of 2.5.

## 3.0.3 / 2020-04-19

- Allow `site.metadata.twitter` data if present. Look for `page.subtitle` if
`page.description` isn't present.

## 3.0.0 / 2020-04-14

- Use Bridgetown gem and rename to bridgetown-seo-tag.
