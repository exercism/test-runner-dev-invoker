#!/usr/bin/env ruby

require "bundler/setup"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "invoker"

Invoker.invoke
