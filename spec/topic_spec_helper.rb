module TopicSpecHelper
  def valid_new_topic
    {
      :name => 'First Topic',
      :user_id => 1,
      :forum_id => 1,
      :parent_id => 1
    }
  end
end