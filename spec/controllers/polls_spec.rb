require File.join(File.dirname(__FILE__), "..", "spec_helper")


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
      #poll stub here?
    end
  
    def do_get(params = {:id => 1}, &block)
      dispatch_to(Polls, :show, params) do |controller|
        controller.stub!(:render)
        block if block_given?
      end
    end
    
    it "should display the vote associated with user_id" do
      #Poll.should_receive(:first).and_return(@poll)
      #Vote.should_receive(:first).and_return(@vote)
      
      do_get({:id => 1}) do
        #controller.session[:user_id] = 1
        p 'here'
        #pp controller
        #controller.stub!(:logged_in?).and_return(true)
        #assigns(:poll).should == @poll
        #assigns(:vote).should == @vote
      end
      
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
end


