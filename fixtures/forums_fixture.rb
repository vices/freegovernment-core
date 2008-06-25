require File.join(File.dirname(__FILE__),'helper')

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
