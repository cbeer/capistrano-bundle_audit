# Capistrano::BundleAudit

Audit your Gemfile for known vulnerabilies before releasing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-bundle_audit'
```

And then execute:

    $ bundle

Add this line to your `Capfile`:

```ruby
require 'capistrano/bundle_audit'
```

## Usage

After `deploy:updating` (and before the deployed code is released as the current version), `bundle-audit` will be run against the pushed code. If any vulnerabilities are discovered, the release will be aborted.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/capistrano-bundle_audit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
