class Person
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :full_name, String, :nullable => false, :length => 100
  property :date_of_birth, Date, :nullable => false
  property :user_id, Integer
  property :description, DM::Text
  property :created_at, DateTime
  property :updated_at, DateTime
  
  validates_present :full_name, :context => [:default, :before_user_creation]
  validates_present :date_of_birth, :context => [:default, :before_user_creation]
  validates_length :full_name, :within => 1..100, :context => [:default, :before_user_creation]
  validates_present :user_id, :context => [:default]
end
