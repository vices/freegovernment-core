class Tagging 
  include DataMapper::Resource
  property :id, Integer, :serial => true
  property :poll_id, Integer
  property :tag_id, Integer

  belongs_to :poll
  belongs_to :tag

end