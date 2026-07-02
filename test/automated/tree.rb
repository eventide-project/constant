# Renders a single, de-duplicated tree of the whole suite's contexts and tests.
#
# It RUNS the tests (so interpolated context names are expanded to their real
# values) with comment/detail output suppressed, captures the run's output, and
# parses that output — the tests' output is parsed, not the source code.
#
#   ruby test/automated/tree.rb
#
# This file is excluded from the default suite run (see the exclude pattern in
# test/automated.rb), so TestBench::Run does not execute it as a test.

require_relative "automated_init"
require "tempfile"

EXCLUDE = "**/{_*,*sketch*,*_init,*_tests,tree}.rb"

# Suppress comment/detail output so the captured run is only contexts and tests.
module TestBench
  module Fixture
    def comment(*); end
    def detail(*); end
  end
end

# TestBench writes to the real stdout (file descriptor 1), not the $stdout
# reference, so capture by redirecting the descriptor to a temp file.
capture = Tempfile.new("test-tree")
saved_stdout = $stdout.dup
$stdout.reopen(capture.path)
begin
  TestBench::Run.("test/automated", exclude: EXCLUDE)
ensure
  $stdout.flush
  $stdout.reopen(saved_stdout)
end
output = File.read(capture.path)
capture.close!

# Merge every file's tree into one. Each line is a context or a test, indented
# two spaces per level; a test is a leaf, a context has children.
root = {}
summary = nil
stack = []
output.each_line do |line|
  text = line.chomp
  stripped = text.strip

  next if stripped.empty?
  if stripped =~ /\A(Attempted|Running|Finished)\b/ || stripped =~ /\A\d+ tests? in\b/
    next
  end
  if stripped =~ /\A\d+ (passed|failed|skipped)\b/
    summary = stripped
    next
  end

  depth = text[/\A */].length / 2
  name = stripped.sub(/ \(failed\)\z/, "")

  stack.pop while stack.any? && stack.last[0] >= depth
  parent = stack.empty? ? root : stack.last[1]
  parent[name] ||= {}
  stack.push([depth, parent[name]])
end

def render(node, indent = 0)
  node.each do |name, children|
    marker = children.empty? ? "• " : ""
    puts("  " * indent + marker + name)
    render(children, indent + 1)
  end
end

render(root)
puts
puts(summary) if summary
