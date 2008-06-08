class Person
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :full_name, String, :nullable => false
  property :date_of_birth, Date, :nullable => false
  property :description, DM::Text
  property :created_at, DateTime
  property :updated_at, DateTime
  
end