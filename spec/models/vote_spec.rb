require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "vote_spec_helper")


describe Vote, "in general"  do
  include VoteSpecHelper
  
  before(:each) do
    Vote.auto_migrate!
    @vote = Vote.new
  end
  
  it "should require a poll id property" do
    @vote.attributes = valid_new_vote.except(:poll_id)
    @vote.should_not be_valid
  end
  
  it "should require a user id property" do
    @vote.attributes = valid_new_vote.except(:user_id)
    @vote.should_not be_valid
  end
  
  it "should require a position property" do
    @vote.attributes = valid_new_vote.except(:position)
    @vote.should_not be_valid
  end
  
  it "should require a controlled_by_advisers property"  do
  	@vote.attributes = valid_new_vote.except(:controlled_by_advisers)
  	@vote.should_not be_valid
  end
  
end

describe Vote, "during adviser vote changes" do
  include VoteSpecHelper

  before(:each) do
    Vote.auto_migrate!
  end

  it "should have a class method update_advisees_votes" do
    Vote.
  end

end