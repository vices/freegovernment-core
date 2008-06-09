class Post
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :text, DM::Text, :nullable => false
  property :user_id, Integer, :nullable => false
  property :forum_id, Integer
  property :topic_id, Integer
  property :parent_id, Integer
  property :created_at, DateTime 
  property :updated_at, DateTime
  
  belongs_to :topic, :forum
end