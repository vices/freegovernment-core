class ContactRelationship
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  include MerbPaginate::Finders::Datamapper
  
  property :id, Integer, :serial => true
  property :person_id, Integer, :nullable => false
  property :contact_id, Integer, :nullable => false
  property :is_accepted, Boolean, :default => 1, :nullable => false
  property :created_at, DateTime
  property :modified_at, DateTime
  
  validates_is_unique :contact_id, :scope => [:person_id]
  
  belongs_to :person
  belongs_to :contact, :class_name => 'Person'
end