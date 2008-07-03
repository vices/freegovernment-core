class BillSection
  include DataMapper::Resource
  include DataMapper::Timestamp

  property :id, Integer, :serial => true
  property :bill_id, Integer, :nullable => false
  property :forum_id, Integer, :nullable => false
  property :topic_id, Integer, :nullable => false
  property :title, DM::Text, :nullable => false
  property :text, DM::Text
end
