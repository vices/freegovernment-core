class Vote
  include DataMapper::Resource
  include DataMapper::Validate
  
  property :id, Integer, :serial => true
  property :poll_id, Integer, :nullable => false
  property :user_id, Integer, :nullable => false
  property :is_yes, Boolean, :default => 0, :nullable => false
  property :is_no, Boolean, :default => 0, :nullable => false
  property :controlled_by_advisers, Boolean, :default => false, :nullable => false
  property :advisers_yes_count, Integer, :default => 0
  property :advisers_no_count, Integer, :default => 0
  
  class << self
    def update_advisees_votes(old_vote, new_vote, advisees_ids)
      query = "\
        update votes set \
        is_yes = (advisers_yes_count + #{new_vote.is_yes} > advisers_no_count + #{new_vote.is_no}), \
        is_no = (advisers_yes_count + #{new_vote.is_yes} < advisers_no_count + #{new_vote.is_no}), \
        advisers_yes_count = advisers_yes_count + #{new_vote.is_yes > old_vote.is_yes ? 1 : 0}, \
        advisers_no_count = advisers_no_count + #{new_vote.is_no > old_vote.is_no ? 1 : 0} \
        where user_id in (#{advisees_ids.join(', ')}) \
        and poll_id = #{new_vote.poll_id} \
      "
      repository.adapter.execute(query)
    end
  end
end