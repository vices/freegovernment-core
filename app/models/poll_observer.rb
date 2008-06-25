class FeedLoggingObserver
  include DataMapper::Observer
  observe Poll, Post
  
  after :save do
    id_class_sym = (self.class.to_s.snake_case + "_id").to_sym
    FeedItem.create!(:user_id => self.user_id, id_class_sym => self.id)
  end
end