ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'

require File.expand_path '../../aptrustauto.rb', __FILE__

