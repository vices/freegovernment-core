require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "poll_spec_helper")


describe Polls, "#new" do

	before(:each) do
	  @new_poll = mock(:poll)
	end

  it "should initialize @new_poll if logged in" do
		Poll.should_receive(:new).and_return(@new_poll)
		dispatch_to(Polls, :new) do |controller|
		   controller.stub!(:logged_in?).and_return(true)
       controller.stub!(:render) #TODO is this used?
    end
  end

end

describe Polls, "#create", "when not logged on" do
  include PollSpecHelper

  it "should not save poll" do
    dispatch_to(Polls, :create, {:poll => valid_new_poll}) do |controller|
      controller.should_receive(:logged_in?).and_return(false)
      @new_poll.should_not_receive(:save)
    end
  end
end

describe Polls, "#create", "invalid captcha" do
  include PollSpecHelper

  it "should render #new if CAPTCHA is incorrect" do
    @params = {:poll => valid_new_poll}
    
    dispatch_to(Polls, :create, @params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      controller.should_receive(:verify_recaptcha).and_return(false)
      controller.should_receive(:render).with(:new)
      controller.stub!(:render)
    end
  end

end


describe Polls, "#create", "valid captcha, invalid data" do
  include PollSpecHelper
  
  it "should render #new again if poll is invalid" do
    @params = {:poll => valid_new_poll}
    @new_poll = mock(:new_poll)
    Poll.stub!(:new).and_return(@new_poll)
    @new_poll.should_receive(:save).and_return(false)
    dispatch_to(Polls, :create, @params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      controller.should_receive(:verify_recaptcha).and_return(true)
      controller.should_receive(:render).with(:new)
      controller.stub!(:render)
    end
  end
end

describe Polls, "#create", "valid poll" do

  it "should show already existing matching poll questions during form completion" #and they should be hyperlinked

  it "should render poll when saved" do
    def do_get(params={}) 
    #does the following line do anything at all? it works without it
    #it also works if return(true) or return(false)
    @new_poll = mock(:poll)
    @new_poll.should_receive(:save).and_return(true)
      dispatch_to(Polls, :show, {:id => "1"}.update(params)) do |controller|
        controller.should_receive(:display).with(@poll)
        controller.stub!(:display)
      end
    end
  end
 
end

describe Polls, "#index" do

  before(:each) do
    @poll = mock(:poll)
    @polls_page = [@poll]
  end
  
  def do_get(params = nil, &block) 
    dispatch_to(Polls, :index, params) do |controller|
      controller.stub!(:render)
      block.call(controller) if block_given?
    end
  end
   
  it "should be succesful" do
    do_get.should be_successful
  end
  
  it "should pull up a pages worth of polls" do
    Poll.stub!(:paginate).and_return(@polls_page)
    Poll.should_receive(:paginate).and_return(@polls_page)
    do_get.assigns(:polls_page).should == @polls_page
  end

  it "should use sort_by and direction to construct order used in all" do
    sort_by = :created_at
    direction = :desc
    params = {:sort_by => sort_by, :direction => direction}
    operator = mock(:operator)
    DataMapper::Query::Operator.stub!(:new).with(sort_by, direction).and_return(operator)
    Poll.should_receive(:paginate).with(:order => [operator], :conditions => [nil]).twice
    do_get(params).assigns(:sort_by).should == sort_by
    do_get(params).assigns(:direction).should == "desc"
  end

  it "should order by question" do
  	sort_by = :question
  	params = {:sort_by => sort_by}
    do_get(params).assigns(:sort_by).should == :question
    do_get(params).assigns(:direction).should == "asc"
  end
  
    it "should order by question" do
  	sort_by = :question
  	direction = :desc
  	params = {:sort_by => sort_by, :direction => direction}
    do_get(params).assigns(:sort_by).should == :question
    do_get(params).assigns(:direction).should == "desc"
  end


  it "should default to order by created_at" do
      do_get.assigns(:sort_by).should == :created_at
      do_get.assigns(:direction).should == "asc"
  end

  
  it "should allow order by number of votes" do
    sort_by = :vote_count
    params = {:sort_by => sort_by}
    Poll.should_receive(:vote_count).twice
    do_get(params).assigns(:sort_by).should == :vote_count
    do_get(params).assigns(:direction).should == "asc"
  end
  
  
  
  it "should allow order by number of yes votes" do
    sort_by = :yes_count
  	params = {:sort_by => sort_by}
    do_get(params).assigns(:sort_by).should == :yes_count
    do_get(params).assigns(:direction).should == "asc"
    end
  
  it "should allow order by number of no votes" do
    sort_by = :no_count
  	params = {:sort_by => sort_by}
    do_get(params).assigns(:sort_by).should == :no_count
    do_get(params).assigns(:direction).should == "asc"
    end
  
  it "should allow filter by number of registered voters" do
    filter_by = :verified_vote_count
    params = {:filter_by => filter_by}
    do_get(params).assigns(Poll).should_receive(:paginate).with(:order => [@order], :conditions => [@filter_by] )
   
    
  end
  
  it "should allow filter by tag"
  
  it "should allow filter/search by question"
  
  it "should allow filter by creator"
  
  it "should allow order by number of topics"
  
  it "should allow order by number of posts"
  
  it "should allow order by controversy" #polls that have close to 50/50 yes/no votes

#    it "should allow filter for bills"
  
end

describe Polls, "#show" do
  before(:each) do
    @poll = mock(:poll)
    @vote = mock(:vote)
    Poll.stub!(:first).and_return(@poll)
    Vote.stub!(:first).and_return(@vote)
  end
  
  def do_get(params = {}, &block)
    dispatch_to(Polls, :show, {:id => 1}.merge(params)) do |controller|
      controller.stub!(:render)
      block.call(controller) if block_given?
    end
  end
  
  it "should be succesful" do
    do_get.should be_successful
  end
  

  it "should get data for poll by id" do
    Poll.should_receive(:first).and_return(@poll)
    do_get
  end
  
  it "should get data for comment stream posts by poll_id" do
    dispatch_to(Polls, :show, {:id => 1}) do |controller|
      controller.stub!(:render)
    end
  end
  
  it "should display an error if poll not found" 
  
end
	


  describe "#destroy" do 
    it "should remove poll data by poll_id"
  
    it "should remove vote_id from poll_id"
  end
