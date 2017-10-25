# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "middleman-brotli"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Daan van Vugt"]
  s.email       = ["daanvanvugt@gmail.com"]
  # s.homepage    = "http://example.com"
  s.summary     = %q{Compresses middleman outputs with brotli}
  s.description = %q{This Middleman extension writes brotli-compressed output files (.br) for your pages, js and css.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  # The version of middleman-core your extension depends on
  s.add_runtime_dependency("middleman-core", [">= 4.2.1"])
  
  # Additional dependencies
  s.add_runtime_dependency("brotli", ">= 0.2.0")
end
