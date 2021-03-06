class Group
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  include MerbPaginate::Finders::Datamapper
  
  property :id, Integer, :serial => true
  property :name, String, :nullable => false, :length => 140
  property :description, DM::Text, :nullable => false
	property :mission, DM::Text
  property :user_id, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  
  validates_present :name, :context => [:default, :before_user_creation]
  validates_length :name, :within => 1..140, :context => [:default, :before_user_creation]
  validates_length :description, :within => 4..500, :context => [:default, :before_user_creation]
  validates_present :user_id, :context => [:default]
  
  has 1, :forum, :class_name => 'Forum'
  
  belongs_to :user
  
  has n, :group_relationships
  
  def members
    self.group_relationships.all(:is_accepted => 1, :order => [:modified_at.desc]).collect{|gr| gr.person}
  end
end
