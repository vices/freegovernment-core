class FeedItem
  include DataMapper::Resource
  include DataMapper::Timestamp
  
  property :id, Integer, :serial => true
  property :user_id, Integer
  property :poll_id, Integer
  property :bill_id, Integer
  property :post_id, Integer
  property :created_at, DateTime
  property :what, String
  property :vote, String
  property :is_private, Boolean, :default => 0
  property :is_hidden, Boolean, :default => 0

  belongs_to :user
  belongs_to :poll
  belongs_to :bill
  belongs_to :post

  before :create do
    self.is_private = User.first(:id => self.user_id).private_profile
  end
end
