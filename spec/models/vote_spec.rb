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

desribe Vote, "when adviser changes vote" do
  include VoteSpecHelper
  
  before(:each) do
    Vote.auto_migrate!
    @advisees_ids = (2..100).to_a
    @advisees_ids.each do |advisee_id|
      vote = Vote.new(advisee_vote.except(:user_id))
      vote.user_id = advisee_id
      case advisee_id % 3
        when 0
          vote.is_yes = 0
          vote.is_no = 0
        when 1
          vote.is_yes = 1
          vote.is_no = 0
        when 2
          vote.is_yes = 0
          vote.is_no = 1
      end
      vote.save
    end
    
    @old_vote = Vote.new
    @new_vote = Vote.new(valid_new_vote)
    @new_vote.save
  end
  
  it "should have a class method update_advisees_votes" do
    Vote.update_advisees_votes(@old_vote,@new_vote,@advisees_ids)
    changed_vote_count = Vote.all(:user_id.in => @advisees_ids).size
    changed_votes.size.should == 99
  end

end

=begin
describe Vote, "when adviser with 1 million advisees changes vote" do
  include VoteSpecHelper

  before(:each) do
    Vote.auto_migrate!
    
    # 1 million advisee vote placeholders well
    @advisees_ids = (2..1000001).to_a
    query = "insert into votes (poll_id, user_id, controlled_by_advisers) values "
    @advisees_ids.each do |advisee_id|
      query << "(1, #{advisee_id}, 1), "
    end
    query = query[0..-3]
    repository.adapter.execute query
    
    # Adviser makes vote
    @old_vote = Vote.new
    @new_vote = Vote.new(valid_new_vote)
    @new_vote.save
  end

  it "should have a class method update_advisees_votes" do
    Vote.update_advisees_votes(@old_vote,@new_vote,@advisees_ids)
    changed_votes = Vote.all(:user_id.in => @advisees_ids)
    changed_votes.size.should == 1000000
  end
end
=end

describe Vote, "upon creation by adviser" do
  include VoteSpecHelper
  
  before(:each) do
    Vote.auto_migrate!
  end
  
  it "should update the positI DUNNO!!! "

  it "should check for previous vote_id associated with poll_id by user_id"
  
  it "should add 1 vote to yes_count of poll_id when position == 1" 
  
  it "should not add 2 votes to yes_count of poll_id when position == 1"
  
  it "should not add any votes to yes_count of poll_id when positon != 1"
  
  it "should check advisers constituents for authorization"
  
  it "should apply 10,000 votes with 10,000 authorizations"

end

describe Vote, "upon creation by user" do
  include VoteSpecHelper
  
  
  it "should check for previous votes on poll_id"
  
  it "should send vote to adviser, when for by_adviser == true, when position == 0"
  
  it "should not submit vote when by_adviser == false, when position == 0"
  

end


describe Vote, "upon establishment of adviser" do

it "should remove all votes from previous by_advisers"

end