class AdviserRelationship
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :adviser_id, Integer, :nullable => false
  property :person_id, Integer, :nullable => false
  property :is_adding_votes, Boolean, :default => 0
  property :is_removing_votes, Boolean, :default => 0
  property :created_at, DateTime
  property :modified_at, DateTime
  
  belongs_to :adviser, :class_name => 'User'
  belongs_to :person, :class_name => 'Person'

  validates_is_unique :person_id, :scope => [:adviser_id]
end
