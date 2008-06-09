class Topic
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :name, String, :nullable => false
  property :forum_id, Integer
  property :created_at, DateTime
  property :user_id, Integer
  property :group_id, Integer
  property :poll_id, Integer
  
  belongs_to :forum
  has n, :posts
end