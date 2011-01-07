# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tamed_beast/version"

Gem::Specification.new do |s|
  s.name        = "tamed_beast"
  s.version     = TamedBeast::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Luca Bonmassar, Andrea Pavoni"]
  s.email       = ["info@coderloop.com"]
  s.homepage    = ""
  s.summary     = %q{Bullettin board for Rails}
  s.description = %q{Provides a simple bullettin board for Rails apps.}

  s.add_dependency('rails', "~> 3.0.3")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end  