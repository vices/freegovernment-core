class FeedLoggingObserver
  include DataMapper::Observer
  observe Bill, User, Poll
  
#  after :save do
#    id_class_sym = (self.class.to_s.snake_case + "_id").to_sym
#    FeedItem.create!(:user_id => self.user_id, id_class_sym => self.id)
#  end

  after :create do
    case self.class.to_s
    when 'User'
      f = FeedItem.create!(:user_id => self.id)
      f.what = 'signup'
      f.save
    when 'Bill'
      f = FeedItem.create!(:user_id => self.user_id, :bill_id => self.id)
      f.what = 'bill'
      f.save
    when 'Poll'
      unless self.bill_id
        f = FeedItem.create!(:user_id => self.user_id, :poll_id => self.id)
        f.what = 'poll'
        f.save
      end
    else
    end
  end

end
