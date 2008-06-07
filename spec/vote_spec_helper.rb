module VoteSpecHelper
  def valid_new_vote
    {
      'poll_id' => 1,
      'user_id' => 1,
      'adviser_controlled' => 0,
      'position' => 1
    }
  end
end