class Poll
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
  include Paperclip::Resource 
  
  property :id, Integer, :serial => true
  property :user_id, Integer, :nullable => false
  property :forum_id, Integer
  property :yes_count, Integer, :default => 0, :writer => :private
  property :no_count, Integer, :default => 0, :writer => :private
 	property :vote_count, Integer, :default => 0, :writer => :private
  property :verified_yes_count, Integer, :default => 0, :writer => :private
  property :verified_no_count, Integer, :default => 0, :writer => :private
  property :verified_vote_count, Integer, :default => 0, :writer => :private
  property :question, String, :nullable => false, :length => 140
  property :description, DM::Text
  property :created_at, DateTime
  property :updated_at, DateTime
  
  has_attached_file :icon,
    :styles => { :small => "60x60#", :medium => "100x100>", :large => "200x200>" },
    :default_url => "polls/missing_icon_:style.png",
    :whiny_thumbnails => true
  
  validates_length :question, :within => 15..140

  def update_for_votes(diffs)
    unless diffs.is_a? Array
      diffs = [diffs]
    end
    yes_agg = 0
    no_agg = 0
    diffs.each do |diff|
      yes_agg = yes_agg + diff[:yes]
      no_agg = no_agg + diff[:no]
    end
    attribute_set(:yes_count, self.yes_count + yes_agg)
    attribute_set(:no_count, self.no_count + no_agg)
    attribute_set(:vote_count, self.yes_count + self.no_count)
    self.save
  end
  
  def yes_percent
    if vote_count > 0
     ( yes_count.to_f  / vote_count.to_f) * 100
    else
      nil
    end
  end
  
  def no_percent
    if vote_count > 0
      ( no_count.to_f ) / vote_count.to_f * 100
    else
      nil
    end
  end

  def verified_yes_percent
    if verified_vote_count > 0
      ( verified_yes_count.to_f ) / verified_vote_count.to_f * 100
    else
      nil
    end
  end
  
  def verified_no_percent
    if verified_vote_count > 0
      ( verified_no_count.to_f ) / verified_vote_count.to_f * 100
    else
      nil
    end  
  end

  has n, :votes

end
