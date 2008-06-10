module ForumSpecHelper
  def valid_new_forum
    {
      :name => 'General Discussion',
      :group_id => nil,
      :poll_id => 2,
      :posts_count => 0,
      :topics_count => 0
      
    }
  end
end