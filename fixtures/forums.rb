require 'rubygems'
require 'merb-core'
require 'pp'
Merb.start

forums = [
  {
    :name => 'Technical Support'
  },{
    :name => 'Site Improvements and Feedback'
  },{
    :name => 'Get Involved!'
  },{
    :name => 'Introduce Yourself'
  },{
    :name => 'Politics in General'
  },{
    :name => 'Everything Else'
  }
]

forums.each do |forum|
  f = Forum.new(forum)
  f.save
  pp f.errors
end
