require 'rubygems'
require 'bundler'

require './sabretache.rb'

set :run, false
set :environment, :production

run Sabretache::Sabretache
