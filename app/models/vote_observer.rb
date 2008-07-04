class VoteObserver
  include DataMapper::Observer
  observe Vote

  after :notify do
    if self.selection != 'adviser' && self.selection != 'undecided'
      f = FeedItem.create!(:user_id => self.user_id, :poll_id => self.poll_id, :vote => self.selection)
      f.what = 'vote'
      f.save
    end
  end


end
