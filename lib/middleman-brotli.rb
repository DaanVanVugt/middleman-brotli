require "middleman-core"

Middleman::Extensions.register :brotli do
  require "middleman-brotli/extension.rb"
  Middleman::Brotli
end
