# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "sampl/version"

Gem::Specification.new do |s|
  s.name          = 'sampl'
  s.version       = Sampl::VERSION
  s.date          = '2014-08-11'
  s.summary       = %q{Report tracking events from a Ruby on Rails server.}
  s.description   = %q{Report tracking events from a Ruby on Rails server.}
  s.authors       = ["Sascha Lange"]
  s.email         = 'sascha@5dlab.com'
  s.homepage      = 'https://github.com/wackadoo/sampl.rb'
  s.license       = 'MIT'

  s.required_ruby_version    = ">= 1.9.3"
  
  s.add_dependency 'httparty', "~> 0.13"

  s.post_install_message = 'Sampl on!'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end