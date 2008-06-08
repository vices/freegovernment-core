module PollsSpecHelper
  def valid_new_poll
    {
      :question => 'Free Government Group?',
      :description => 'FREE GOVERNMENT GROUP!',
      :created_at => '1324-23-42-32-42-32',
      :user_id => 'Tom Hamburg'
    }
  end
end