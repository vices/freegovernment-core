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


describe Vote, "when user votes" do
  include VoteSpecHelper
  
  before(:each) do
    Vote.auto_migrate!
  end




  
  it "should set is_yes, is_no, etc via selection=" do
    @new_vote = Vote.new(valid_new_vote.merge({:selection => 'yes'}))
    @new_vote.attributes[:is_yes].should == true
    @new_vote.attributes[:is_no].should == false
  end
  
  it "should translate is_yes, is_no, etc via selection" do
    @new_vote = Vote.new(valid_new_vote.merge({:selection => 'adviser'}))
    @new_vote.selection.should == 'adviser'
    
    @new_vote = Vote.new(valid_new_vote.merge({:selection => 'yes'}))
    @new_vote.selection.should == 'yes'
    
    @new_vote = Vote.new(valid_new_vote.merge({:selection => 'no'}))
    @new_vote.selection.should == 'no'
    
    @new_vote = Vote.new(valid_new_vote.merge({:selection => 'undecided'}))
    @new_vote.selection.should == 'undecided'
  end
  
  it "should translate is_yes, is_no to state" do
    @new_vote = Vote.new(valid_new_vote.update({:selection => 'yes'}))
    @new_vote.attributes[:is_yes].should == true
    @new_vote.state.should == 1
    @new_vote = Vote.new(valid_new_vote.update({:selection => 'no'}))
    @new_vote.attributes[:is_no].should == true
    @new_vote.state.should == -1
    @new_vote = Vote.new(valid_new_vote.update({:selection => 'undecided'}))
    @new_vote.attributes[:is_yes].should == false
    @new_vote.attributes[:is_no].should == false
    @new_vote.state.should == 0
  end

  
  
end

describe Vote, "when updating advisee votes" do
  include VoteSpecHelper
  
  before(:each) do
    Vote.auto_migrate!
  end

  it "should pull up a list of advisee votes" do
    advisee_ids = (1..10).to_a
    old_vote = Vote.new(valid_new_vote.merge({:position => 'undecided'}))
    new_vote = Vote.new(valid_new_vote)
    votes = Vote.should_receive(:all).and_return([])#.with(:poll_id => 1, :user_id.in => advisee_ids)
    Vote.update_advisee_votes(old_vote, new_vote, advisee_ids)
  end



  it "should return a list of changes" do
    advisee_ids = (1..10).to_a
    old_vote = Vote.new(:user_id => 11, :poll_id => 1, :selection => 'undecided')
    new_vote = Vote.new(:user_id => 11, :poll_id => 1, :selection => 'yes')
    changes = Vote.update_advisee_votes(old_vote, new_vote, advisee_ids)
    Vote.count.should == 10
    Vote.count(:is_yes => true, :is_no => false).should == 10
    

    old_vote = Vote.new(:user_id => 11, :poll_id => 1, :selection => 'yes')
    new_vote = Vote.new(:user_id => 11, :poll_id => 1, :selection => 'no')
    changes = Vote.update_advisee_votes(old_vote, new_vote, advisee_ids)
    Vote.count.should == 10
    Vote.count(:is_yes => false, :is_no => true).should == 10
    

    old_vote = Vote.new(:user_id => 11, :poll_id => 1, :selection => 'no')
    new_vote = Vote.new(:user_id => 11, :poll_id => 1, :selection => 'undecided')
    changes = Vote.update_advisee_votes(old_vote, new_vote, advisee_ids)
    Vote.count.should == 10
    Vote.count(:is_yes => false, :is_no => false).should == 10
    
  end




end

describe Vote, "populate advisee list" do

  before(:each) do
    Vote.auto_migrate!
  end

  it "should have a class method for populating advisee votes" do
    Vote.populate_advisee_votes(1, '1')
    Vote.count.should == 1
  end
  
  it "should result in a vote for all advisees" do
    advisee_ids = (1..10).to_a
    # Throw in an already created vote
    Vote.create(:poll_id => 1, :user_id => 5)
    # Creates votes for all advisee's without one
    Vote.populate_advisee_votes(1, advisee_ids)
    # Make sure we didn't make a duplicate
    Vote.count.should == 10
  end
  
  it "should not overwrite or modify previous votes" do
    @new_vote = Vote.create(:poll_id => 1, :user_id => 777, :selection => 'yes')
    Vote.populate_advisee_votes(1, '777')
    @new_vote.attributes[:is_yes].should == true
  end
  
end

describe Vote, "describe changes and differences in votes" do
  include VoteSpecHelper
  before :each do
    @old_vote = Vote.new(valid_new_vote)
    @new_vote = Vote.new(valid_new_vote)
    @change = Vote.describe_change(@old_vote, @new_vote)
    @difference = Vote.describe_difference(@change)
  end
  
  
  it "should have a class method to describe change from old vote to new vote" do
    @old_vote = Vote.new(valid_new_vote.merge({:selection => 'yes'}))
    #new(valid_new_vote.merge({:selection => 'yes'}))
    new_vote = Vote.new(valid_new_vote.merge({:selection => 'undecided'}))
    change = Vote.describe_change(@old_vote, new_vote)
    change.should == [1, 0]
    
    @old_vote = nil
    change = Vote.describe_change(@old_vote, new_vote)
    change.should == [0, 0]
  end
  
  it "should have a class method to describe the difference in a vote change" do
    change = [1,0]
    difference = Vote.describe_difference(change)
    difference[:yes].should == -1
    difference[:no].should == 0
  end
  
  it "should have a decribed difference of 0,0 when switching from no to no" do 
    old_vote = Vote.new(valid_new_vote.merge({:selection=> 'no'}))
    new_vote = Vote.new(valid_new_vote.merge({:selection=> 'no'}))
    change = Vote.describe_change(old_vote, new_vote)
    difference = Vote.describe_difference(change) 
    difference[:yes].should == 0
    difference[:no].should == 0
  end
  it "should have a descrbied difference of 0,1 when undecided to no" do 
    old_vote = Vote.new(valid_new_vote.merge({:selection=> 'undecided'}))
    new_vote = Vote.new(valid_new_vote.merge({:selection=> 'no'}))
    change = Vote.describe_change(old_vote, new_vote)
    difference = Vote.describe_difference(change) 
    difference[:yes].should == 0
    difference[:no].should == 1
  end
  
  it "should hae a described difference of :yes => 1, :no => -1 when no to yes" do
    old_vote = Vote.new(valid_new_vote.merge({:selection=> 'no'}))
    new_vote = Vote.new(valid_new_vote.merge({:selection=> 'yes'}))
    change = Vote.describe_change(old_vote, new_vote)
    difference = Vote.describe_difference(change) 
    difference[:yes].should == 1
    difference[:no].should == -1
  end
  
  
  
  it "should have a described difference of 0,1 when yes to no" do
    old_vote = Vote.new(valid_new_vote.merge({:selection=> 'yes'}))
    new_vote = Vote.new(valid_new_vote.merge({:selection=> 'no'}))
    change = Vote.describe_change(old_vote, new_vote)
    difference = Vote.describe_difference(change)
    difference[:yes].should == -1
    difference[:no].should == 1  
  end

  it "should not have a described difference of -1,-1 when no to no" do
    old_vote = Vote.new(valid_new_vote.merge({:selection=> 'no'}))
    new_vote = Vote.new(valid_new_vote.merge({:selection=> 'no'}))
    change = Vote.describe_change(old_vote, new_vote)
    difference = Vote.describe_difference(change)
    difference[:yes].should_not == -1
    difference[:no].should_not == -1
  end
end