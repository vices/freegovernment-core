require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "vote_spec_helper")
require File.join(File.dirname(__FILE__), "..", "poll_spec_helper")

describe Votes, "#create", "when not logged in" do
  include VoteSpecHelper
  
  it "should not save vote unless logged in" do
    @vote = mock(:vote)
    Vote.stub!(:new).and_return(@vote)
    @vote.should_not_receive(:save)
    dispatch_to(Votes, :create, :vote => valid_new_vote) do |controller|
      controller.should_receive(:logged_in?).and_return(false)
    end
  end
end

describe Votes, "#create", "when logged in", "when vote valid" do
  include VoteSpecHelper

  before(:each) do
    @old_vote = mock(:old_vote)
    @new_vote = mock(:new_vote)
    @params = {:vote => valid_new_vote}
  end

  def do_post(params = @params, &block)
    dispatch_to(Votes, :create, params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      controller.assigns(:new_vote).stub!(:save)
      controller.stub!(:set_old_and_new_vote)
      controller.stub!(:update_poll_for_vote)
      controller.stub!(:clean_vote_for_advisers)
      controller.stub!(:change_advisee_votes_and_update_poll)
    end
  end

  it "should set old and new votes" do
    do_post do |controller|
      controller.assigns(:new_vote).stub!(:save).and_return(false)
      controller.should_receive(:set_old_and_new_vote)
    end
  end

  it "should save vote if valid" do
    do_post do |controller|
      controller.assigns(:new_vote).should_receive(:save)
    end
  end
  
  it "should redirect to poll page" do
    do_post do |controller|
      controller.should redirect_to url(:poll, :id => valid_new_vote[:id])
    end
  end
  
  it "should update poll after vote is saved" do
    do_post do |controller|
      controller.should_receive(:update_poll_for_vote)
      #@new_vote.should_receive(:update_for_votes)
    end
    
  end
  
  it "should update advisee votes after vote is saved" do
    do_post do |controller|
      controller.should_receive(:change_advisee_votes_and_update_poll)
    end
  end
end


describe Votes, "#create", "set_old_and_new_vote" do
  include VoteSpecHelper

  before(:each) do
    @old_vote = mock(:old_vote)
    @new_vote = mock(:new_vote)
    @params = {:vote => valid_new_vote}
  end
  
  it "should find an old vote if it exists" do
    @old_vote.stub!(:poll_id).and_return(1)
    @old_vote.stub!(:selection).and_return('yes')
    @old_vote.stub!(:user_id).and_return(2)
   
    dispatch_to(Votes, :create, @params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      controller.assigns(:new_vote).stub!(:save)  
      #controller.stub!(:update_poll_for_vote)
      controller.stub!(:change_advisee_votes_and_update_poll)
      controller.stub!(:session).and_return({:user_id => 1})
      controller.stub!(:clean_vote_for_advisers)
      @old_vote.stub!(:selection=)
      @old_vote.stub!(:save)
      Vote.stub!(:first).with(:poll_id => valid_new_vote[:poll_id], :user_id => controller.session[:user_id]).and_return(@old_vote)
      Vote.should_receive(:first).with(:user_id => controller.session[:user_id], :poll_id => valid_new_vote[:poll_id]).and_return(@old_vote)
    end
  end
  
  it "should not find an old vote if it does not exist" do
    dispatch_to(Votes, :create, @params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      controller.assigns(:new_vote).stub!(:save)
      #controller.stub!(:update_poll_for_vote)
      controller.stub!(:change_advisee_votes_and_update_poll)
      controller.stub!(:session).and_return({:user_id => 1})
      controller.stub!(:clean_vote_for_advisers)
      @new_vote.stub!(:save)
      Vote.should_receive(:first).and_return(nil)
      Vote.should_receive(:new).and_return(@new_vote)
      
    end
  end


end

describe Votes, "#create", "update_poll_for_vote" do
  include VoteSpecHelper
 
  before(:each) do
    @old_vote = mock(:old_vote)
    @new_vote = mock(:new_vote)
    @params = {:vote => valid_new_vote}
  end

  def do_post(params = @params, &block)
    dispatch_to(Votes, :create, params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:set_old_and_new_vote) # it shouldn't see it, this metod is stubbed
      controller.assigns(:new_vote).stub!(:save).and_return(true)
      controller.stub!(:change_advisee_votes_and_update_poll)
      block.call(controller) if block_given?
    end
  end
 
  it "should set update poll with vote change" do
    do_post do |controller|
      Vote.should_receive(:describe_change)#.and_return(vote_change)
      vote_diff = mock(:vote_diff)
      Vote.stub!(:describe_difference).and_return(vote_diff)
      Vote.stub!(:describe_change)
      poll = mock(:poll)
      controller.assigns(:new_vote).stub!(:poll).and_return(poll)
      poll.should_receive(:update_for_votes).with(vote_diff)
    end
  end
end


=begin
describe Votes, "#create", "change_advisee_votes_and_update_poll" do
include VoteSpecHelper

  before(:each) do
    @old_vote = mock(:old_vote)
    @new_vote = mock(:new_vote)
    @params = {:vote => valid_new_vote}
  end
  
  def do_it
    @controller = dispatch_to(Votes, :create, {:username => @user.username, :password => @user.password})
  end
  
  it "should update advisee votes and poll with changes if current user is adviser" do

    dispatch_to(Votes, :create, @params) do |controller|
      #controller.stub!(:logged_in?).and_return(true)
      controller.assigns(:new_vote).stub!(:save).and_return(true)      
      controller.stub!(:update_poll_for_vote)
      controller.stub!(:set_old_and_new_vote)
      controller.stub!(:clean_vote_for_advisers)
     
      controller.assigns(:current_user).should_receive(:is_adviser?).and_return(true)
      #controller.assigns(:current_user).should_receive(:advisee_list)
      #Vote.should_receive(:update_advisee_votes)
      #Poll.should_receive(:update_for_multiple_votes)
    end
  end
end


  it "should update advisee votes and poll with changes if current user is adviser" do
    do_post do |controller|
      controller.assigns(:current_user).should_receive(:is_adviser?).and_return(true)
      controller.assigns(:current_user).should_receive(:advisee_list)
      Vote.should_receive(:update_advisee_votes)
      Poll.should_receive(:update_for_multiple_votes)
    end
  end
end
=end

describe Votes, "#create", "change_advisee_votes_and_update_poll" do
  include VoteSpecHelper
 
  before(:each) do
    @old_vote = mock(:old_vote)
    @new_vote = mock(:new_vote)
    @params = {:vote => valid_new_vote}
  end
  
  it "should update advisee votes and poll with changes if current user is advser" do
    dispatch_to(Votes, :create, @params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:set_old_and_new_vote)
      controller.assigns(:new_vote).stub!(:save).and_return(true)
      controller.stub!(:update_poll_for_vote)
      controller.assigns(:current_user).should_receive(:is_adviser?).and_return(true)
      controller.assigns(:current_user).should_receive(:advisee_list)
      controller.assigns(:new_vote).stub!(:poll_id)
      vote_diff = mock(:vote_diff)
      Vote.should_receive(:update_advisee_votes).and_return(vote_diff)
      poll = mock(:poll)
      Poll.should_receive(:first).with(:id => valid_new_vote[:id]).and_return(poll)
      poll.should_receive(:update_for_votes).with(vote_diff)
    end
  end

end

describe Votes, "#create", "clean_poll_for_advisers" do
  include VoteSpecHelper

  before(:each) do
    @old_vote = mock(:old_vote)
    @new_vote = mock(:new_vote)
    @params = {:vote => valid_new_vote}
  end

  it "when 'yes'" do
  dispatch_to(Votes, :create, @params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      pp :current_user
      controller.assigns(:current_user)
      @current_user.should_receive(:is_adviser).and_return(true)
      controller.stub!(:session).and_return({:user_id => 1})
      controller.stub!(:selection).and_return('yes')
      controller.stub!(:params).with(:selection => 'yes')
#      @old_vote.stub!(:attributes).and_return(@old_vote)
#      @old_vote.stub!(:except)
#      @old_vote.stub!(:stance=)
#      @old_vote.stub!(:save)
#      @old_vote.stub!(:selection).and_return('yes')
      end
  end

end
