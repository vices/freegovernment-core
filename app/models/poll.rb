class Poll
  include DataMapper::Resource
  include DataMapper::Validate
  include DataMapper::Timestamp
#  include MerbAuth::ControllerMixin
  
  property :id, Integer, :serial => true
  property :user_id, Integer, :nullable => false
  property :forum_id, Integer
  property :yes_count, Integer, :default => 0, :writer => :private
  property :no_count, Integer, :default => 0, :writer => :private
  property :registered_yes_count, Integer, :default => 0, :writer => :private
  property :registered_no_count, Integer, :default => 0, :writer => :private
  property :question, String, :nullable => false, :length => 140
  property :description, DM::Text
  property :created_at, DateTime
  property :updated_at, DateTime
  
  validates_length :question, :within => 15..140

  def update_poll_for_votes(diffs)
    unless diffs.is_a? Array
      diffs = [diffs]
    end
    yes_agg = 0
    no_agg = 0
    diffs.each do |diff|
      yes_agg = yes_agg + diff[:yes]
      no_agg = no_agg + diff[:no]
    end
    self.yes_count = self.yes_count + yes_agg
    self.no_count = self.no_count + no_agg
  end

end