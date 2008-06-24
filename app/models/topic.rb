class Topic
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :name, String, :nullable => false, :length => 140
  property :forum_id, Integer, :nullable => false
  property :user_id, Integer, :nullable => false
  property :group_id, Integer
  property :poll_id, Integer
  property :posts_count, Integer, :default => 0
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_length :name, :within => 1..140
  belongs_to :forum, :class_name => 'Forum' 
  has n, :posts
  
  belongs_to :user
end