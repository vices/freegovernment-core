class Post
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :text, DM::Text, :nullable => false, :length => 10000
  property :user_id, Integer, :nullable => false
  property :topic_id, Integer, :nullable => false
  property :parent_id, Integer
  property :created_at, DateTime
  property :updated_at, DateTime
  
  validates_length :text, :within => 1..100
  
  belongs_to :parent, :class_name => "Post"
  belongs_to :topic
  belongs_to :user
end
