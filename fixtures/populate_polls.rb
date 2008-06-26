require File.join(File.dirname(__FILE__),'helper')

user_count = User.count

(user_count*8).times do
  srand()
  user_id = 1 + rand(user_count)
  question_length = 15 + rand(140-15)
  description_length = rand(65000)
  p = Poll.create!(:question => random_text(question_length), :description => random_text(description_length), :user_id => user_id)
  forum = Forum.create!(:poll_id => p.id, :name => p.question)
  Topic.create!(:forum_id => forum.id, :name => 'Comments', :user_id => user_id)
end


poll_count = Poll.count

user_id = 1
poll_id = 1
yes_count = 0
no_count = 0
(poll_count*user_count).times do
  srand()
  preselection = rand(3)
  case(preselection)
    when 1
      Vote.create!(:user_id => user_id, :poll_id => poll_id, :selection => 'yes')
      yes_count = yes_count + 1
    when 2
      Vote.create!(:user_id => user_id, :poll_id => poll_id, :selection => 'no')
      no_count = no_count + 1
  end
  if user_id == user_count
    user_id = 1
    poll = Poll.first(:id => poll_id)
    poll.update_for_votes({:yes => yes_count, :no => no_count})
    poll_id = poll_id + 1
    yes_count = 0
    no_count = 0
  else
    user_id = user_id + 1
  end
end
