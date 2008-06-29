class Tag 
  include DataMapper::Resource
  include DataMapper::Validate


  
  property :id, Integer, :serial => true
  property :name, String, :nullable => false, :length => 30
  property :permalink, String, :length => 1000
  property :poll_id, Integer, :nullable => false
  
  attr_accessor :poll_tag_list
  
  has n, :taggings
  
  belongs_to :taggings


  before :create do 
    pp "self"
    self.permalink = self.name.downcase.gsub(/[^a-z0-9]+/i, '')
  end


def create_poll_tags(poll)
 pp "function called"

  @poll = poll
  return if @poll.tag_list.nil? || @poll.tag_list.empty?
  
  pp "tag list is:"
  pp @poll.tag_list
  pp "@poll.taggings = "
  pp @poll.taggings
  #@poll.taggings.each {|t| t.destroy}
  @poll.taggings.each {|t| t.destroy}
  pp "taggings destroyed, see, @poll.taggings ="
  pp @poll.taggings
  @poll.tag_list.split(",").each do |t|
  pp "tag list split into: "
  pp t
    unless t.empty?
      if ( tag = Tag.first(:name => t.strip.downcase, :poll_id => poll.id).nil?)
  pp "poll id is"
  pp poll.id
        tag = Tag.create(:name => t.strip.downcase, :poll_id => poll.id)
        pp "tag created!"
      end
      poll.taggings << Tagging.create(:poll_id => poll.id, :tag_id => tag.id)
      pp "tagging created!"
    end
  end
end
=begin
 def create_tags
    pp "function called"
    return if @tag_list.nil? || @tag_list.empty?
    # Wax all the existing taggings
    pp "before taggings"
    self.taggings.each {|t| t.destroy! }
    pp "before split"
    @tag_list.split(",").each do |t|
     pp "after split"
     
      unless t.empty?
        pp "t wasn't empty"
        #TODO need poll_id in first
        if ( tag = Tag.first(:name => t.strip.downcase)).nil? 
          tag = Tag.create(:name => t.strip.downcase) 
          pp "tag was created"
        end
        #TODO change poll_id to model_id variable
          @poll.taggings << Tagging.create(:poll_id => @poll.id, :tag_id => tag.id)
          pp "self taggings"
      end
     end
  end
=end

  def tags
    taggings.collect{ |tagging| tagging.tag }
  end

=begin
  def tag_list
    if @tag_list.nil?
      taggings.collect{ |tagging| tagging.tag.name }.join(", ")
    else
      @tag_list
    end
  end
=end
  ##
  # Has many through would be nice here
  
  def polls
    Poll.all(:id => taggings.collect{|t| t.poll_id })
  end

  def to_param
    permalink
  end
end