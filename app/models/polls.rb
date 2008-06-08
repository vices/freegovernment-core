class Poll
  include DataMapper::Resource
  include DataMapper::Validate
  
  property :id, Integer, :serial => true
  property :poll_id, Integer, :nullable => false
  property :user_id, Integer, :nullable => false
  property :topic_id, String
  property :constituents_yes_count, Integer, :default => 0
  property :constituents_no_count, Integer, :default => 0
end