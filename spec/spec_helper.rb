require 'rubygems'
require 'bundler'
Bundler.require

require_relative '../lib/semantic_versioning'

def v(i)
  SemanticVersioning::Version.new(i)
end