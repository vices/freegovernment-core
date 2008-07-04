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

  belongs_to :user
  belongs_to :poll
  belongs_to :bill
  belongs_to :post

end