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
  
  belongs_to :user
  
  has n, :group_relationships
  
  def members(options = {:page => 1, :per_page => 6})
    self.group_relationships.all(:is_accepted => 1).paginate(:page => options[:page], :per_page => options[:per_page]).collect{|gr| gr.person}
  end
end
