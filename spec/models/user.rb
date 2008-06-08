class User
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
end