class Group
  include DataMapper::Resource
  
  property :id, Integer, :serial => true
  property :name, String, :nullable => false, :length => 20
  property :description, DM::Text, :nullable => false, :length => 500
	property :mission, DM::Text, :nullable => false
  property :user_id, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  
  validates_present :name, :context => [:default, :before_user_creation]
  validates_length :name, :within => 1..20, :context => [:default, :before_user_creation]
  validates_length :description, :within => 4..500, :context => [:default, :before_user_creation]
  validates_present :user_id, :context => [:default]
end
