# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tamed_beast/version"

Gem::Specification.new do |s|
  s.name        = "tamed_beast"
  s.version     = TamedBeast::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Luca Bonmassar, Andrea Pavoni"]
  s.email       = ["info@coderloop.com"]
  s.homepage    = "http://github.com/coderloop/tamed_beast"
  s.summary     = %q{Bullettin board for Rails 3}
  s.description = %q{Provides a simple bullettin board for Rails 3 apps.}

  s.add_dependency 'rails', "~> 3.0.3"
  s.add_dependency 'will_paginate', "~> 3.0.beta"
  s.add_dependency 'acts_as_list'


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end  
