require File.join(File.dirname(__FILE__), 'helper')

user_count = User.count

(user_count*2).times do
  srand()
  user_id = 1 + rand(user_count)
  title = random_text(10+rand(490))
  if rand(2) == 1
    summary = random_text(20+rand(1000))
  else
    summary = nil
  end
  srand()
  if rand(2) == 1
    text = ""
    i = 1
    rand(10).times do
      text = text + "SEC. #{i}. "+random_text(5+rand(20)).upcase
      text = text + "\n" + random_text(10+rand(800)) + "\n\n"
      i = i + 1
    end
  else
    text = random_text(20+rand(1000))
  end
  @new_bill = Bill.new({:title => title, :text => text, :summary => summary, :user_id => user_id})        
  if @new_bill.save
    poll = Poll.create(:question => "Do you support FG Bill ##{@new_bill.id}?", :description => @new_bill.title, :user_id => user_id)
    forum = Forum.create(:name => "FG Bill ##{@new_bill.id} - #{@new_bill.title}".ellipsis(140), :bill_id => @new_bill.id, :poll_id => poll.id, :topics_count => 1)
    poll.forum_id = forum.id
    poll.save
    Topic.create(:forum_id => forum.id, :name => 'Comments', :user_id => user_id)
  end
end
