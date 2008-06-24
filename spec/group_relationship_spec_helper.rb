module GroupRelationshipsSpecHelper
  def valid_new_relationship
    {
      :group_id => 1,
      :person_id => 1,
      :is_accepted => true
    }
  end
end