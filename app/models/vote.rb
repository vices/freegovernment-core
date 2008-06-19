class Vote
  include DataMapper::Resource
  include DataMapper::Validate
  
  property :id, Integer, :serial => true
  property :poll_id, Integer, :nullable => false
  property :user_id, Integer, :nullable => false
  property :is_yes, Boolean, :default => 0, :nullable => false, :writer => :private
  property :is_no, Boolean, :default => 0, :nullable => false, :writer => :private
  property :is_adviser_decided, Boolean, :default => true, :nullable => false, :writer => :private
  property :adviser_yes_count, Integer, :default => 0, :writer => :private
  property :adviser_no_count, Integer, :default => 0, :writer => :private
  
  validates_is_unique :poll_id, :scope => [:user_id]
  
  belongs_to :poll
  belongs_to :user
  
  # How user sets vote
  attr_accessor :selection
  
  def selection=(value)
    case(value)
      when 'yes'
        attribute_set(:is_yes, true)
        attribute_set(:is_no, false)
        attribute_set(:is_adviser_decided, false)
      when 'no'
        attribute_set(:is_no, true)
        attribute_set(:is_yes, false)
        attribute_set(:is_adviser_decided, false)
      when 'undecided'
        attribute_set(:is_no, false)
        attribute_set(:is_yes, false)
        attribute_set(:is_adviser_decided, false)
      else
        attribute_set(:is_adviser_decided, true)
    end
  end
  
  def selection
    if !is_adviser_decided
      if is_yes and !is_no
        'yes'
      elsif !is_yes and is_no
        'no'
      else
        'undecided'
      end
    else
      'adviser'
    end
  end
  

  # Poll counted state of vote
  def state
    if is_yes and !is_no
      1
    elsif !is_yes and is_no
      -1
    else
      0
    end
  end



  # Change adviser counts and affect vote state
  def change_adviser_counts(dy, dn)
    self.adviser_yes_count = self.adviser_yes_count + dy
    self.adviser_no_count = self.adviser_no_count + dn
    
    if self.adviser_yes_count > self.adviser_no_count
      self.state = 1
    elsif self.adviser_yes_count < self.adviser_no_count
      self.state = -1
    else
      self.state = 0
    end
  end

  class << self
 
    def update_advisee_votes(old_vote,new_vote,advisee_ids)
      vote_differences = []
      vote_change = Vote.describe_change(old_vote, new_vote)
      vote_difference = Vote.describe_difference(vote_change)
      Vote.populate_advisee_votes(old_vote.poll_id, advisee_ids)
      votes_to_change = Vote.all(:poll_id => old_vote.poll_id, :user_id.in => advisee_ids)
      votes_to_change.each do |vote|
        before_state = vote.state
        vote.change_adviser_counts(vote_difference[:yes],vote_difference[:no])
        vote.save
        vote_differences << describe_difference([before_state, vote.state])
      end
      vote_differences
    end

    def populate_advisee_votes(poll_id, advisee_ids)
      DataMapper::Transaction.new do
        advisee_ids.each do |advisee_id|
          Vote.create(:poll_id => poll_id, :user_id => advisee_id)
        end
      end
    end

    def describe_change(old_vote, new_vote)
      unless old_vote.nil?
        [old_vote.state, new_vote.state]
      else
        [0, new_vote.state]
      end
    end

    def describe_difference(vc)
      if vc[0] != vc[1]
        case(vc[0])
          when 0
            case(vc[1])
              when 1
                dy = 1
                dn = 0
              when -1
                dy = 0
                dn = 1
            end
          when 1
            case(vc[1])
              when 0
                dy = -1
                dn = 0
              when -1
                dy = -1
                dn = 1
            end
          when -1
            case(vc[1])
              when 0 
                dy = 0
                dn = -1

                when 1
                dy = 1
                dn = -1
            end
        end
#TOO FAR! GO UP!
      else
        dy = 0
        dn = 0
      end
      {:yes => dy, :no => dn}
    end

  end

  private
  
  # How vote state is changed after adviser changes
  def state=(value)
    case(value)
      when 0
        attribute_set(:is_yes, false)
        attribute_set(:is_no, false)
      when 1
        attribute_set(:is_yes, true)
        attribute_set(:is_no, false)
      when -1
        attribute_set(:is_yes, false)
        attribute_set(:is_no, true)
    end

  end

end