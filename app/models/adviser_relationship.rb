class AdviserRelationship
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :adviser_id, Integer, :nullable => false
  property :person_id, Integer, :nullable => false
  property :created_at, DateTime
  property :modified_at, DateTime
  
  has 1, :adviser, :class_name => 'User'
  has 1, :person

  validates_is_unique :person_id, :scope => [:adviser_id]
end
