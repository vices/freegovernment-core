module VoteSpecHelper
  def valid_new_vote
    {
      :poll_id => 1,
      :stance => 'yes'
    }
  end
  
  def adviser_vote
    {
      :poll_id => 1,
      :user_id => 1,
      :controlled_by_advisers => false,
      :is_yes => 1,
      :is_no => 0
    }
  end
  
  def advisee_vote
    {
      :poll_id => 1,
      :user_id => 2,
      :controlled_by_advisers => true,
      :is_yes => 1,
      :is_no => 0
      
    }
  end
  
end
