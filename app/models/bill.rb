class Bill
  include DataMapper::Resource
  include DataMapper::Timestamp
  include DataMapper::Validate
  include MerbPaginate::Finders::Datamapper 
  include DataMapper::Timestamp

  property :id, Integer, :serial => true
  property :title, String, :length => 1000
  property :summary, DM::Text
  property :text, DM::Text, :nullable => false
  property :user_id, Integer, :nullable => false
  property :poll_id, Integer
  property :forum_id, Integer
  property :created_at, DateTime

  belongs_to :user
  has 1, :forum, :class_name => "Forum"
  has 1, :poll
  has n, :bill_sections


  def text=(value)
    value.gsub!("\r\n", "\n")
    attribute_set(:text, value)
  end

end
