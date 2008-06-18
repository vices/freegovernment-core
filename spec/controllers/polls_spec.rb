require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "polls_spec_helper")

describe "#new" do

  it "should initialize @new_poll" do
  @new_poll = Poll.new

  end

end

describe Polls, "#create", "when not logged on" do
  include PollsSpecHelper

  it "should not save poll" do
    dispatch_to(Polls, :create, {:poll => valid_new_poll}) do |controller|
      controller.should_receive(:logged_in?).and_return(false)
      @new_poll.should_not_receive(:save)
    end
  end
end

describe Polls, "#create", "valid poll" do

end






=begin
  #mock vs stub?  do I need @new_poll = Poll.new ?
  it "should not save poll and it should render login" do
    #first we need a poll object
    #@new_poll = mock(:poll)
    @new_poll = Poll.new 
    #now we tell it that it is not logged in (what is it?)((it is polls/create))
    dispatch_to(Polls, :create, :poll => valid_new_poll) do |controller|
      #ok ok we tell it "are you logged in?"
      controller.should_receive(:logged_in?).and_return(false)
      #and it tells us "NO!"  In theory.  However, it is not receiving that order
      #Where oh where does the green rabbit run?
      #in which case it should not receive a save demand from us!
      @new_poll.should_not_receive(:save)
      controller.should_receive(:render) #but god doesnt want this
      #it were not the sheep that focked the shepard, but instead the gnomes
      controller.stub!(:render)#there are some codes that you can only run green once
      #Dear lord of the gambit, please allow your cats free reign over our teradactyls
    
    end
    end
 =end
    

  end

describe Polls, "#create", "when logged on" do


  it "should save the poll"   do

  end
end






=end














=begin
describe Polls do
  describe "#new" do 
    before(:each) do
      @new_poll = mock(:poll)
      @new_forum = mock(:forum)
      @new_topic = mock(:topic)
      @new_post = mock(:post)
    end
  
    it "should initialize polls/forums/topics/posts" do
      #what we need
      Poll.should_receive(:new).and_return(@new_poll)
      Forum.should_receive(:new).and_return(@new_forum)
      Topic.should_receive(:new).and_return(@new_topic)
      Post.should_receive(:new).and_return(@new_post)
      
      dispatch_to(Polls, :new)
    end
    
    end
  end
  describe "#create" do 
  
      before(:each) do
        @params = {:poll => '', :forum => '', :topic => '', :post => ''}
        @new_poll = mock(:poll)
        @new_forum = mock(:forum)
        @new_topic = mock(:topic)
        @new_post = mock(:post)
        Poll.should_receive(:new).and_return(@new_poll)
        Forum.should_receive(:new).and_return(@new_forum)
        Topic.should_receive(:new).and_return(@new_topic)
        Post.should_receive(:new).and_return(@new_post)
        @new_forum.stub!(:valid?).and_return(true)
        @new_topic.stub!(:valid?).and_return(true)
        @new_post.stub!(:valid?).and_return(true)
      end
      
      it "should render #new if CAPTCHA is incorrect" do
        dispatch_to(Polls, :create, @params) do |controller|
          controller.should_receive(:verify_recaptcha).and_return(false)
          controller.should_receive(:render).with(:new)
        end
       end
      
      it "should render #new again if poll is invalid in the before creation context" do
        @new_poll.should_receive(:valid?).with(:before_poll_creation).and_return(false)
        dispatch_to(Polls, :create, @params) do |controller|
          controller.should_receive(:verify_recaptcha).and_return(true)
          controller.should_receive(:render).with(:new)
          controller.stub!(:render)
        end
      end
      
    describe "with valid models and correct CAPTCHA" do
        after(:each) do
          dispatch_to(Polls, :create, @params) do |controller|
            controller.should_receive(:verify_recaptcha).and_return(true)
          end
        end
      
      
      it "should require correct CAPTCHA" do
        @new_poll.stub!(:valid?).and_return(false)
      end
  
      it "should show already existing matching poll questions during form completion" #and they should be hyperlinked
  
      it "should create a new poll/forum/topic/post when poll valid" do
        @new_poll.should_receive(:valid?).and_return(true)
        @new_forum.should_receive(:save).and_return(true)
        @new_topic.should_receive(:save).and_return(true)
        @new_post.should_receive(:save).and_return(true)
        @new_poll.should_receive(:save)

      end
    end

    it "should render poll when saved"
=begin      def do_get(params={})
      
      #@new_poll.should_receive(:save).and_return(true)
      
        dispatch_to(Polls, :show, {:id => "1"}.update(params)) do |controller|
          controller.should_receive(:display).with(@poll)
          controller.stub!(:display)
        end
      end
    end
 =end

    it "should render #new if poll data invalid" do
      @new_poll.should_receive(:valid?).with(:before_poll_creation).and_return(false)
#Mock 'forum' expected :save with (any args) once, but received it 0 times
      #@new_forum.should_receive(:save).and_return(false)
      #@new_topic.should_receive(:save).and_return(false)
      #@new_post.should_receive(:save).and_return(false)
      dispatch_to(Polls, :create, @params) do |controller|
        controller.should_receive(:verify_recaptcha).and_return(true)
        controller.should_receive(:render).with(:new)
        controller.stub!(:render)
      end
    end
  end
  
  
  
  
  
  describe "#index" do 
  
    before(:each) do
      @poll = mock(:poll)
      @polls_page = [@poll]
    end
    
    def do_get(params = nil, &block) 
      dispatch_to(Polls, :index, params) do |controller|
        controller.stub!(:render)
        block if block_given?
      end
    end
    
    it "should be succesful" do
      do_get.should be_successful
    end
    
    it "should pull up a pages worth of polls" do
      Poll.stub!(:all).and_return(@polls_page)
      Poll.should_receive(:all).and_return(@polls_page)
      do_get.assigns(:polls_page).should == @polls_page
    end
  
    it "should use sort_by and direction to construct order used in all" do
      sort_by = :created_at
      direction = :desc
      params = {:sort_by => sort_by, :direction => direction}
      operator = mock(:operator)
      DataMapper::Query::Operator.stub!(:new).with(sort_by, direction).and_return(operator)
      Poll.should_receive(:all).with(:order => [operator])
      do_get(params) do
        assigns(:sort_by).should == sort_by
        assigns(:direction).should == direction
      end
    end
  
    it "should default to order by created_at" do
      do_get do
        assigns(:sort_by).should == :created_at
        assigns(:direction).should == :desc
      end
    end
    
    
    it "should allow order by location"
    
    it "should allow order by number of votes"
    
    it "should allow order by number of yes votes"
    
    it "should allow order by number of no votes"
    
    it "should allow filter by number of registered voters" #filter and order for registered voters?
    
    it "should allow filter/order by category"
    
    it "should allow filter/search by question"
    
    it "should allow filter by creator"
    
    it "should allow order by topics"
    
    it "should allow order by posts"
    
    it "should allow order by controversy" #polls that have close to 50/50 yes/no votes

#    it "should allow filter for bills"
    
  end
  
  describe "#show" do
  
    before(:each) do
      @poll = mock(:poll)
      @vote = mock(:vote)
      Poll.stub!(:first).and_return(@poll)
      Vote.stub!(:first).and_return(@vote)
    end
  
    def do_get(params = {}, &block)
      dispatch_to(Polls, :show, {:id => 1}.merge(params)) do |controller|
        controller.stub!(:render)
        block if block_given?
      end
    end
    it "should be succesful" do
      do_get.should be_successful
    end
    
    it "should get the vote associated with user_id" do
#      Poll.should_receive(:first).and_return(@poll)
#      Vote.should_receive(:first).and_return(@vote)    
      do_get.assigns(:poll).should == @poll
      do_get.assigns(:vote).should == @vote
      
    
      #Poll.should_receive(:first).and_return(@poll)
      #Vote.should_receive(:first).and_return(@vote)
    # do_get({:id => 1}) do
        #controller.session[:user_id] = 1
     #   p 'here'
        #pp controller
        #controller.stub!(:logged_in?).and_return(true)
        #assigns(:poll).should == @poll
        #assigns(:vote).should == @vote
      #end
      end
    
    
 
    it "should get data for poll by id" do
      Poll.should_receive(:first).and_return(@poll)
      do_get
    end
    
    it "should get data for comment stream posts by poll_id"
    
    it "should display an error if poll not found"

  end
  
  
  describe "#destroy" do 
    it "should remove poll data by poll_id"
  
    it "should remove vote_id from poll_id"
  end
    
  
  describe "#update" do end  
  describe "#edit" do end

=end
