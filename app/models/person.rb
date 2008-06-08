class Person
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :full_name, String, :nullable => false, :length => 100
  property :date_of_birth, Date, :nullable => false
  property :description, DM::Text
  property :created_at, DateTime
  property :updated_at, DateTime
  
	validates_present :full_name, :date_of_birth
	validates_length :full_name, :within => 1..100
end