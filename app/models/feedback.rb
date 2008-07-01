class Feedback
  include DataMapper::Resource

  property :id, Integer, :serial => true
  property :message, String
  property :user_id, Integer
  property :controller, String
  property :action, String
end