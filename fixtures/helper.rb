require 'rubygems'
require 'merb-core'
require 'pp'

Merb.start_environment(:environment => ENV['MERB_ENV'] || 'development')
