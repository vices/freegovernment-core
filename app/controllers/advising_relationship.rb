class AdvisingRelationship
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :adviser_id, Integer, :nullable => false
  property :user_id, Integer, :nullable => false
  property :created_at, DateTime
  property :modified_at, DateTime
  
  has 1, :adviser, :class_name => 'User'
  has 1, :user
end
