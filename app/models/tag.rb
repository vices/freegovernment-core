class Tag 
  include DataMapper::Resource
  include DataMapper::Validate
  
  property :id, Integer, :serial => true
  property :name, String, :nullable => false, :length => 30
  property :permalink, String
  
 
  
  has n, :taggings
  
  belongs_to :taggings

=begin
  before_create do |tag|
    tag.permalink = tag.name.downcase.gsub(/[^a-z0-9]+/i, '-')
  end
=end

  ##
  # Has many through would be nice here
  def polls
    Poll.all(:id => taggings.map{|t| t.poll_id })
  end

  def to_param
    permalink
  end
end