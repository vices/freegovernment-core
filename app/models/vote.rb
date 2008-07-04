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

  def notify
  end

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
        case(self.adviser_yes_count <=> self.adviser_no_count)
          when 0
            attribute_set(:is_no, false)
            attribute_set(:is_yes, false)
          when 1
            attribute_set(:is_no, false)
            attribute_set(:is_yes, true)            
          when -1
            attribute_set(:is_no, true)
            attribute_set(:is_yes, false)
        end
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

    if self.is_adviser_decided   
      if self.adviser_yes_count > self.adviser_no_count
        self.state = 1
      elsif self.adviser_yes_count < self.adviser_no_count
        self.state = -1
      else
        self.state = 0
      end
    end
  end

  def clear_adviser_counts
    self.adviser_yes_count = 0
    self.adviser_no_count = 0
    if self.is_adviser_decided
      self.state = 0
    end
  end

  class << self
 
    def update_advisee_votes(old_vote,new_vote,advisee_ids)
      vote_differences = []
      unless advisee_ids.empty?
        vote_change = Vote.describe_change(old_vote, new_vote)
        vote_difference = Vote.describe_difference(vote_change)
        Vote.populate_advisee_votes(new_vote.poll_id, advisee_ids)

        votes_to_change = Vote.all(:poll_id => new_vote.poll_id, :user_id.in => advisee_ids)
        votes_to_change.each do |vote|
          before_state = vote.state
          vote.change_adviser_counts(vote_difference[:yes],vote_difference[:no])
          vote.save
          vote_differences << describe_difference([before_state, vote.state])
        end
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
      else
        dy = 0
        dn = 0
      end
      {:yes => dy, :no => dn}
    end

    def update_user_votes_for_added_adviser(user_id, adviser_id)
      votes = Vote.all(:user_id => adviser_id)
      poll_changes = []
      votes.each do |vote|
        v = Vote.new(:user_id => user_id, :poll_id => vote.poll_id)
        y0 = 0
        n0 = 0
        v.change_adviser_counts(vote.is_yes ? 1 : 0, vote.is_no ? 1 : 0)
        unless v.save
          vi = Vote.first(:user_id => user_id, :poll_id => vote.poll_id)
          y0 = vi.is_yes ? 1 : 0
          n0 = vi.is_no ? 1 : 0
          vi.change_adviser_counts(vote.is_yes ? 1 : 0, vote.is_no ? 1 : 0)
          vi.save
          v = vi
        end
        dy = (v.is_yes ? 1 : 0) - y0
        dn = (v.is_no ? 1 : 0) - n0
        Merb.logger.warn 'the bad must be in here'
        Merb.logger.warn y0.to_s
        Merb.logger.warn n0.to_s
        Merb.logger.warn dy.to_s
        Merb.logger.warn dn.to_s
        poll_changes << {:poll_id => v.poll_id, :yes => dy, :no => dn }
      end
      poll_changes
    end

    def update_user_votes_for_removed_adviser(user_id, adviser_id)
      Merb.logger.warn('update remove')
      votes = Vote.all(:user_id => adviser_id)
      poll_changes = []
      votes.each do |vote|
        vi = Vote.first(:user_id => user_id, :poll_id => vote.poll_id)
        vi.change_adviser_counts(vote.is_yes ? -1 : 0, vote.is_no ? -1 : 0)
        y0 = vote.is_yes ? 1 : 0
        n0 = vote.is_no ? 1 : 0
        vi.save
        dy = (vi.is_yes ? 1 : 0) - y0
        dn = (vi.is_no ? 1 : 0) - n0
        poll_changes << {:poll_id => vi.poll_id, :yes => dy, :no => dn}
      end
      poll_changes
    end   


    def update_votes_after_adviser_change(user_ids, poll_ids)
      Vote.all(:user_id.in => user_ids, :poll_id.in => poll_ids, :is_adviser_decided => true, :adviser_yes_count.gt => :adviser_no_count).update!(:is_yes => 1, :is_no => 0)
      Vote.all(:user_id.in => user_ids, :poll_id.in => poll_ids, :is_adviser_decided => true, :adviser_yes_count.lt => :adviser_no_count).update!(:is_yes => 0, :is_no => 1)
      Vote.all(:user_id.in => user_ids, :poll_id.in => poll_ids, :is_adviser_decided => true, :adviser_yes_count.eql => :adviser_no_count).update!(:is_yes => 0, :is_no => 0)
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
