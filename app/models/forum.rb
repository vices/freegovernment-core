class Forum
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :name, String, :length => 140, :nullable => false
  property :posts_count, Integer, :default => 0
  property :topics_count, Integer, :default => 0
  property :group_id, Integer
  property :poll_id, Integer
  property :created_at, DateTime
  property :updated_at, DateTime
  

  has n, :topics
  has n, :posts
end