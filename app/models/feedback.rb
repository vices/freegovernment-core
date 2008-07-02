class Feedback
  include DataMapper::Resource
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :message, String
  property :user_id, Integer
  property :controller, String
  property :action, String
  property :created_at, DateTime
end