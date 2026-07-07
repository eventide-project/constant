# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = "evt-constant"
  s.summary = ""
  s.version = "2.1.0.1"
  s.description = "Utilities for importing constants and inspecting constants"

  s.authors = ["The Eventide Project"]
  s.email = "opensource@eventide-project.org"
  s.homepage = "https://github.com/eventide-project/constant"
  s.licenses = ["MIT"]

  s.require_paths = ["lib"]
  s.files = Dir.glob("{lib}/**/*")
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 4"

  s.add_runtime_dependency "evt-initializer"

  s.add_development_dependency "test_bench"
end
