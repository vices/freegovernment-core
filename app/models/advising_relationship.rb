class AdvisingRelationship
  include DataMapper::Resource
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :adviser_id, Integer, :nullable => false
  property :advisee_id, Integer, :nullable => false
  property :created_at, DateTime
  
  has 1, :adviser, :class_name => 'User'
  has 1, :advisee, :class_name => 'User'
end
