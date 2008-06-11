module PostSpecHelper
  def valid_new_post
    {
      :text => 'It\'s all for one and one for all.',
      :user_id => 1,
      :topic_id => 1,
      :forum_id => 1,
      :parent_id => 1
    }
  end
  
  def valid_reponse_post
    {
      :text => 'It\'s all for one and one for all.',
      :user_id => 1,
      :parent_id => 1,
      :topic_id => 1
    }
  end
end