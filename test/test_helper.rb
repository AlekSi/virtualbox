require 'rubygems'

# ruby-debug, not necessary, but useful if we have it
begin
  require 'ruby-debug'
rescue LoadError; end

require 'contest'
require 'mocha'

# The actual library
require File.join(File.dirname(__FILE__), '..', 'lib', 'virtualbox')