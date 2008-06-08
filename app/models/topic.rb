class Topic
  include DataMapper::Resource
  include DataMapper::Validate
  
  property :id, Integer, :serial => true
  property :poll_id, Integer, :nullable => false
  property :user_id, Integer, :nullable => false
  property :topic_id, String
end