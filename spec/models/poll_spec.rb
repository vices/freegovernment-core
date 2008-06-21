require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "poll_spec_helper")

describe Poll, "in general"  do
  include PollSpecHelper

  before(:each) do
    Poll.auto_migrate!
    @poll = Poll.new
  end

  it "should require a question" do
    @poll.attributes = valid_new_poll.except(:question)
    @poll.valid?
    @poll.errors.on(:question).should_not be_nil
  end
  
  it "should only allow questions between 15 and 140 chars" do
    (1..14).each do |num|
      @poll.question = "a" * num
      @poll.valid?
      @poll.errors.on(:question).should_not be_nil    
    end
    (15..140).each do |num|
      @poll.question = "a" * num
      @poll.valid?
      @poll.errors.on(:question).should be_nil
    end
    @poll.question = "a" * 141
    @poll.valid?
    @poll.errors.on(:question).should_not be_nil
  end
  
  it "should respond to description" do
    @poll.should respond_to(:description)
  end
  
  it "should require a user_id" do
    @poll.attributes = valid_new_poll.except(:user_id)
    @poll.valid?
    @poll.errors.on(:user_id).should_not be_nil
  end

  it "should respond to a registered_yes_count" do
    @poll.should respond_to(:registered_yes_count)
  end
  
  it "should respond to a registered_no_count" do
    @poll.should respond_to(:registered_no_count)
  end
    
  it "should respond to a yes_count" do
    @poll.should respond_to(:yes_count)
  end
  it "should respond to a no_count" do
    @poll.should respond_to(:no_count)
  end
  it "should respond to a forum_id" do
    @poll.should respond_to(:forum_id)
  end
  

end

describe Poll, "upon creation" do

  include PollSpecHelper
  
  before(:each) do
    Poll.auto_migrate!
    @poll = Poll.new(valid_new_poll)
    @poll.save
  end
    
  it "should default to a yes_count of 0" do
    @poll.yes_count.should == 0
  end
    
  
  it "should default to a no_count of 0" do
    @poll.no_count.should == 0
  end

  it "should default to a registered_yes_count of 0" do
    @poll.registered_yes_count.should == 0
  end
  
  it "should default to a registered_no_count of 0" do
    @poll.registered_no_count.should == 0 
  end

  it "should record created_at" do
    @poll.created_at.should_not be_nil
    @poll.created_at.class.should == DateTime
  end
  
  it "should record updated_at" do
    @poll.updated_at.should_not be_nil
    @poll.updated_at.class.should == DateTime
  end
  
end

describe Poll, "updating for vote changes" do
  include PollSpecHelper
  before(:each) do
    @poll = Poll.new
  end
  
  it "should handle single vote difference" do
    diff = {:yes => 1, :no => 0}
    @poll.update_for_votes(diff)
    @poll.yes_count.should == 1
    @poll.no_count.should == 0
  end
  
  it "should handle arrays of vote differences" do
    diffs = [{:yes => 1, :no => 0}, {:yes => 1, :no => -1}]
    @poll.update_for_votes(diffs)
    @poll.yes_count.should == 2
    @poll.no_count.should == -1
    
  end
  
  it "should total the vote count"  do
    @poll.attribute_set(:yes_count, 1)
    @poll.attribute_set(:no_count, 1)
    @poll.vote_count.should 
    @poll.total_count.should == 2
  end
  
  it "should get verified vote count" do
    @poll.attribute_set(:verified_yes_count, 1)
    @poll.attribute_set(:verified_no_count, 1)  
    @poll.verified_vote_count.should == 2
  end
  
  it "should calculate yes percent" do
    @poll.stub!(:vote_count).and_return(20)
    @poll.stub!(:yes_count).and_return(10)
    @poll.yes_percent.should == 50
  end
  
  it "should not divide by zero when vote count = 0" do
    @poll.stub!(:vote_count).and_return(0)
    @poll.yes_percent.should be_nil
  end
  
    it "should calculate no percent" do
    @poll.stub!(:vote_count).and_return(20)
    @poll.stub!(:no_count).and_return(10)
    @poll.no_percent.should == 50
  end
  
  it "should not divide by zero when vote count = 0" do
    @poll.stub!(:vote_count).and_return(0)
    @poll.no_percent.should be_nil
  end
  
    it "should calculate verified yes percent" do
    @poll.stub!(:verified_vote_count).and_return(20)
    @poll.stub!(:verified_yes_count).and_return(10)
    @poll.verified_yes_percent.should == 50
  end
  
  it "should not divide by zero when verified vote count = 0" do
    @poll.stub!(:verified_vote_count).and_return(0)
    @poll.verified_yes_percent.should be_nil
  end
  
    it "should calculate verified no percent" do
    @poll.stub!(:verified_vote_count).and_return(20)
    @poll.stub!(:verified_no_count).and_return(10)
    @poll.verified_no_percent.should == 50
  end
  
  it "should not divide by zero when verified vote count = 0" do
    @poll.stub!(:verified_vote_count).and_return(0)
    @poll.verified_no_percent.should be_nil
  end
end
