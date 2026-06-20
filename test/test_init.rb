ENV["CONSOLE_DEVICE"] ||= "stdout"
ENV["LOG_TAGS"] ||= "_all,_untagged"
ENV["LOG_LEVEL"] ||= "_min"

ENV["TEST_BENCH_DETAIL"] ||= ENV["D"]

puts RUBY_DESCRIPTION

require_relative '../init.rb'
require 'constant/controls'

require 'test_bench'; TestBench.activate

Controls = Constant::Controls
