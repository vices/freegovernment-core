module ContactRelationshipsSpecHelper
  def valid_new_relationship
    {
      :user_id => 1,
      :person_id => 1,
      :is_accepted => true
    }
  end
end