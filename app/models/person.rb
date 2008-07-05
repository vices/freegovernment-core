class Person
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  include MerbPaginate::Finders::Datamapper
  
  property :id, Integer, :serial => true
  property :full_name, String, :nullable => false, :length => 100
  property :date_of_birth, Date, :nullable => false
  property :user_id, Integer
  property :description, DM::Text
  property :political_beliefs, DM::Text
  property :political_affiliation, String
  property :political_view, String
  property :interests, DM::Text
  property :created_at, DateTime
  property :updated_at, DateTime
  
  validates_present :full_name, :context => [:default, :before_user_creation]
  validates_present :date_of_birth, :context => [:default, :before_user_creation]
  validates_length :full_name, :within => 1..100, :context => [:default, :before_user_creation]
  validates_present :user_id, :context => [:default]
  
  belongs_to :user
  
  has n, :contact_relationships
  has n, :group_relationships

  def contacts
    self.contact_relationships.all(:is_accepted => 1, :order => [:modified_at.desc]).collect{|cr| cr.contact}
  end
  
  def groups
    self.group_relationships.all(:is_accepted => 1, :order => [:modified_at.desc]).collect{|gr| gr.group}
  end

  def advisers
    AdviserRelationship.all(:person_id => self.id, :order => [:modified_at.desc]).collect{|ar| ar.adviser}
  end
end
