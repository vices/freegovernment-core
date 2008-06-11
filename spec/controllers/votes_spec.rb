require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Votes do

  describe "#create" do
    before(:each) do
      @new_vote = mock(:vote)
      Vote.stub!(:new).and_return(@new_vote)
      @current_user = mock(:user)
      User.stub!(:new).and_return(@current_user)    
    end
    
    it "should check if user is adviser after save" do
      @new_vote.should_receive(:save).and_return(true)
      @current_user.should_receive(:is_adviser)
      dispatch_to(Votes, :create, {:vote => 'fake'})
    end
  end

  describe "#create", "as adviser" do
    before(:each) do
      @new_vote = mock(:vote)
      Vote.stub!(:new).and_return(@new_vote)
      @current_user = mock(:user)
      User.stub!(:new).and_return(@current_user)
      @advisee = mock(:user)
      @advisees = [@advisee]
      @new_vote.stub!(:save).and_return(true)
      @current_user.stub!(:is_adviser).and_return(true)
    end

    it "should check if user is adviser after save and create or update all advisee votes if so" do
      @current_user.should_receive(:advisees).and_return(@advisees)
      
      dispatch_to(Votes, :create, {:vote => 'fake'}) do |controller|
        controller.stub!(:current_user).and_return(@user)
      end
    end
  end
  
  describe "#create", "as user" do
    before(:each) do
      @new_vote = mock(:vote)  
      Vote.stub!(:new).and_return(:@new_vote)
      @current_user = mock(:user)
      User.stub!(:new).and_return(@current_user)
      @advisee = mock(:user)
    end 
    
    it "should check advisers selection if by_advisers == true"
    
    it "should submit vote to poll if position != 0"
   
  end
  
    
  describe "#update" do
    it "should update vote if already existing and valid"
    
    it "should add 1 vote to yes_count of vote poll_id when is_yes = 1" do
    
      @poll = Poll.stub!(:first).and_return(@poll)
      @vote = Vote.stub!(:first).and_return(@vote)
      @vote.attributes = {:is_yes => 1}
      @poll.attributes = { :yes_count => 0, :user_id => 1, :poll_id => 1 }
      @poll.should_recieve(:update_attributes).with({:yes_count => @poll.yes_count + 1})  
      lambda { @poll.update_attributes()}.should change(@poll.yes_count).by(1)
      @poll.yes_count.should == yes_count + 1
      
    end
  end
    it "should update all advisees votes if valid vote updated by adviser"
  end

end