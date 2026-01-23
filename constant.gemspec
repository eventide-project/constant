# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = "evt-constant"
  s.summary = ""
  s.version = "0.0.0.0"
  s.description = "Utilities for working with constants. Avoid the unintended effects of including constants by aliasing their inner constants."

  s.authors = ["The Eventide Project"]
  s.email = "opensource@eventide-project.org"
  s.homepage = "https://github.com/eventide-project/constant"
  s.licenses = ["MIT"]

  s.require_paths = ["lib"]
  s.files = Dir.glob("{lib}/**/*")
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 3.0"

  s.add_runtime_dependency "evt-log"

  s.add_development_dependency "test_bench"
end
