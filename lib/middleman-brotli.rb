require "middleman-core"

Middleman::Extensions.register :middleman-brotli do
  require "my-extension/extension"
  MyExtension
end
