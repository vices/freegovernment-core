require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "vote_spec_helper")

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
      controller.stub!(:update_poll_for_vote)
    end
  end
  
  it "should update advisee votes after vote is saved" do
    do_post do |controller|
      controller.stub!(:change_advisee_votes_and_update_poll)
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

  def do_post(params = @params, &block)
    dispatch_to(Votes, :create, params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      controller.assigns(:new_vote).stub!(:save)
      controller.stub!(:update_poll_for_vote)
      controller.stub!(:change_advisee_votes_and_update_poll)
      controller.stub!(:session).and_return({:user_id => 1})
      @old_vote.stub!(:attributes).and_return(@old_vote)
      @old_vote.stub!(:except)
      @old_vote.stub!(:stance=)
      @old_vote.stub!(:save)
      block.call(controller) if block_given?
    end
  end
  
  it "should check for a previous vote" do
    do_post do |controller|
      Vote.should_receive(:first).with(:poll_id => valid_new_vote[:poll_id], :user_id => controller.session[:user_id]).and_return(@old_vote)
      controller.assigns(:old_vote) == @old_vote
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
      controller.assigns(:new_vote).stub!(:save).and_return(true)
      controller.stub!(:change_advisee_votes_and_update_poll)
      controller.stub!(:set_old_and_new_vote)
      block.call(controller) if block_given?
    end
  end
 
  it "should set update poll with vote change" do
    do_post do |controller|
      vote_change = mock(:vote_change)
      Vote.should_receive(:describe_change).and_return(vote_change)
      Poll.should_receive(:update_for_vote).with(vote_change)
    end
  end
end

describe Votes, "#create", "change_advisee_votes_and_update_poll" do
  include VoteSpecHelper
 
  before(:each) do
    @old_vote = mock(:old_vote)
    @new_vote = mock(:new_vote)
    @params = {:vote => valid_new_vote}
  end

  def do_post(params = @params, &block)
    dispatch_to(Votes, :create, params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      controller.assigns(:new_vote).stub!(:save).and_return(true)
      controller.stub!(:update_poll_for_vote)
      controller.stub!(:set_old_and_new_vote)
      block.call(controller) if block_given?
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