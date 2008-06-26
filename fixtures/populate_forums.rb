require File.join(File.dirname(__FILE__),'helper')

forum_count = Forum.count
user_count = User.count

(forum_count*8).times do
  srand()
  forum_id = 1 + rand(forum_count)
  user_id = 1 + rand(user_count)
  Topic.create!(:forum_id => forum_id, :name => random_text(25), :user_id => user_id)
end

topic_count = Topic.count

(topic_count*user_count).times do
  srand()
  topic_id = 1 + rand(topic_count)
  user_id = 1 + rand(user_count)
  Post.create!(:topic_id => topic_id, :text => random_text(75), :user_id => user_id)  
end
