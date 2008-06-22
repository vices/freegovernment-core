class GroupRelationship
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :user_id, Integer, :nullable => false
  property :group_id, Integer, :nullable => false
  property :is_accepted, Boolean, :default => 1, :nullable => false
  
  property :created_at, DateTime
  property :modified_at, DateTime
end