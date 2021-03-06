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

  it "should respond to a verified_yes_count" do
    @poll.should respond_to(:verified_yes_count)
  end
  
  it "should respond to a verified_no_count" do
    @poll.should respond_to(:verified_no_count)
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

  it "should default to a verified_yes_count of 0" do
    @poll.verified_yes_count.should == 0
  end
  
  it "should default to a verified_no_count of 0" do
    @poll.verified_no_count.should == 0 
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
  
  it "should subtract 1 from total_count when yes -> undecided" do
    diffs = [{:yes => -1, :no => 0}]
    @poll.update_for_votes(diffs)
    @poll.yes_count.should == -1
    @poll.no_count.should == 0
    @poll.vote_count.should == -1

  end
    
  
  
  it "should total the vote count"  do
    @poll.update_for_votes({:yes => 1, :no => 1})
    @poll.vote_count.should == 2
  end
  
  # Not Applicable Yet
  #it "should get verified vote count" do
  #  @poll.update_for_votes({:yes => 1, :no => 1})
  #  @poll.verified_vote_count.should == 2
  #end
  
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

  
describe Poll, "#tags" do 
  include PollSpecHelper 
  before(:each) do 
    Poll.auto_migrate! 
    Tag.auto_migrate!
    @poll = Poll.new 
  end

  it "should have a tag_list accessor" do
    @poll.should respond_to(:tag_list) 
  end

=begin
  it "should find a tag if it exists"  do
    #@poll.attributes = valid_new_poll.merge(:tag_list => "osf")
    #Tag.stub!(:first).with(nil)
    @poll = mock(:poll)
    @poll.stub!(:create_tags)
    @poll.stub!(:tag_list).and_return("osf")
    
    #@tag = mock(:tag)
    #Tag.stub!(:first).with(:name => "osf")
    Tag.should_receive(:first).with(:name => "osf").and_return(:fingers)
    @poll.create_tags
  end


      Vote.stub!(:first).with(:poll_id => valid_new_vote[:poll_id], :user_id => controller.session[:user_id]).and_return(@old_vote)
      Vote.should_receive(:first).with(:user_id => controller.session[:user_id], :poll_id 
      => valid_new_vote[:poll_id]).and_return(@old_vote)
=end

  it "should search for a tag from the :tag_list" do
    @poll.attributes = valid_new_poll.merge(:tag_list => "osf")
    Tag.should_receive(:first).with(:name => "osf")
    @poll.create_tags
  end

  it "should create a tag if it is not found" do
    @poll.attributes = valid_new_poll.merge(:tag_list => "osfive")
    Tag.should_receive(:create).with(:name => "osfive")
    @poll.create_tags
  end
  
  it "should create taggings for poll_id and tag_id" do
    @poll.tag_list = "five"
    @poll.stub!(:id).and_return(1) 
    Tagging.should_receive(:create).with(:poll_id => 1, :tag_id => 1).and_return(@new_tagging)
    @poll.create_tags
  end
  #    taggings.collect{ |tagging| tagging.tag.name }.join(", ")
  
  it "should get the tagging text with tags_text" do
    #@poll.stub!(:taggings).and_return("five")
    
    @poll.taggings.should_receive(:collect)
    pp @poll.tags
    #pp @poll.tags_text
  end
  
=begin
  it "should make a new tag if it doesn't exist" do
  mock tag
  taglist = stuff
  stub first and return nil
  tag should receive first and return nil
  stub create and return @new_tag
  tag should receive create and return @new tag
  end


=begin
  it "should create taggings for poll_id and tag_id"  do
  mock tagging
  stub tag id =
  stub poll id = 
  stub tagging create and return taggings
  tagging.should recieve create with tag_id and poll_id and return taggings
  
  end
  
  it "should get list of tags from tags_text" do
  mock tag
  stub taggings collect with tags
  taggings should receive collect with tagging.tag.name and return joined tags
  
  end
=end
  
  it "should create a something" do  #for test purposes, tag_list must be changed in order to go to "create", otherwise it is "found" with first
    @poll.attributes = valid_new_poll.merge(:tag_list => "osf@@ssC, tCs3sfCCSSod, TSsCCfd")
    #@poll.tag_list.should == ['one','two','three'] 
    #@new_tag = mock(:tag)
    #Tag.stub!(:create).and_return(@new_tag)
    #Tag.should_receive(:first).exactly(3).times
    #Tag.should_receive(:create).with(:name => "one").and_return(@new_tag)
    #Tag.should_receive(:create).tywice
    #Tagging.should_receive(:create).exactly(3).times
    
    
    
    @poll.create_tags
    @poll.tags.should == "one, two, three"
    
    
    #pp @poll.Tag.permalink
    
    #@poll.tag_list.should == "blah"
    #Tag.stub!(:first).and_return(:name => 'one')
    
    
    #Tag.should_receive(:first).with(:name => 'one')
    #Tag.first.name.should == "one"
    
   
   end

end