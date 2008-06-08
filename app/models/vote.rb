class Vote
  include DataMapper::Resource
  include DataMapper::Validate
  
  property :id, Integer, :serial => true
  property :poll_id, Integer, :nullable => false
  property :user_id, Integer, :nullable => false
  property :position, Integer, :default => 0, :nullable => false
  property :controlled_by_advisers, Boolean, :default => false, :nullable => false
  property :advisers_yes_count, Integer, :default => 0
  property :advisers_no_count, Integer, :default => 0
  
  class << self
    def update_advisees_votes(new_vote, advisees_ids)
      query = "
        update votes set
        position = (advisers_yes_count + #{new_vote.position} <=> advisers_no_count),
        advisers_yes_count = advisers_yes_count + #{new_vote.position}, 
        advisers_no_count = advisers_no_count + #{new_vote.position}*-1
        where user_id in (#{advisees_ids.join(', ')})
      "
      repository.adapter.execute query
    end
  end
end