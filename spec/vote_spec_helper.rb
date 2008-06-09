module VoteSpecHelper
  def valid_new_vote
    {
      :poll_id => 1,
      :user_id => 1,
      :controlled_by_advisers => false,
      :position => 1
    }
  end
  
  def advisee_vote
    {
      :poll_id => 1,
      :user_id => 2,
      :controlled_by_advisers => true,
      :position => 0
    }
  end
  
end
