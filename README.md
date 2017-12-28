# Middleman-brotli extension

This extension compresses assets with brotli for maximum shrinkage.
Based on the gzip compressor from middleman core.

## Installation 
Add the gem to your `.gemrc`

```ruby
gem 'middleman-brotli', git: 'https://github.com/exteris/middleman-brotli', branch: 'master'
```

and activate it in your `config.rb`:

```ruby
configure :build do
  active :brotli
end
```

You might need to apply some other settings to your web server and CDN.
See for instance [This page](https://afasterweb.com/2016/03/15/serving-up-brotli-with-nginx-and-jekyll/).

## Improvements
* Detect filetype and apply font, text or generic compression types

# LICENSE
This project is released under the MIT license.
