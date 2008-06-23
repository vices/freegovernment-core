require 'rubygems'
require 'merb-core'
require 'pp'
Merb.start

u = User.new(
  :username => 'tester',
  :email => 'tester@test.com',
  :password => 'password',
  :password_confirmation => 'password'
)
u.save
p = Person.new(
  :full_name => 'Test Person',
  :date_of_birth => '1950-01-01',
  :user_id => u.id
)
p.save
u.person_id = p.id
u.save
