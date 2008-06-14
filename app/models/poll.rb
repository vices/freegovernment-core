class Poll
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
#  include MerbAuth::ControllerMixin
  
  property :id, Integer, :serial => true
  property :user_id, Integer, :nullable => false
  property :forum_id, Integer
  property :yes_count, Integer, :default => 0
  property :no_count, Integer, :default => 0
  property :registered_yes_count, Integer, :default => 0
  property :registered_no_count, Integer, :default => 0
  property :question, String, :nullable => false, :length => 140
  property :description, DM::Text
  property :created_at, DateTime
  property :updated_at, DateTime
  
  validates_length :question, :within => 15..140

end