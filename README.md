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
  activate :brotli
end
```

You might need to apply some other settings to your web server and CDN.
See for instance [This page](https://afasterweb.com/2016/03/15/serving-up-brotli-with-nginx-and-jekyll/).

## Options
The files to compress can be selected by extension, with an optional ignore list.
Default options are:

```ruby
  option :exts, %w(.css .htm .html .js .svg .xhtml .otf .woff .ttf .woff2), 'File extensions to compress when building.'
  option :ignore, [], 'Patterns to avoid compressing'
  option :overwrite, false, 'Overwrite original files instead of adding .br extension.'
```

They can be set as:
```ruby
configure :build do
  activate :brotli, ignore: 'tinyfile.js'
end
```

## Improvements
* Detect filetype and apply font, text or generic compression types (Brotli comes with different default dictionaries for these types of files)
* We could generalize the gzip plugin to just use multiple compression commands

# LICENSE
This project is released under the MIT license.
