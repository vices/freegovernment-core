require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "topics_spec_helper")
require 'merb_param_protection'

describe Topics, "#show" do
  
  before(:each) do
  
  end

  it "should show all of the posts in a topic" do
    
    @topic = mock(:topic)
    @topic.stub!(:id=).with(1)
    @topic.stub!(:posts)
    Topic.should_receive(:first).and_return(@topic)
    dispatch_to(Topics, :show) do |controller|
      @topic.should_receive(:posts).and_return(:posts_page)
      controller.assigns(:posts_page)
      controller.stub!(:render)
      controller.should_receive(:render)
    end
  end
end

describe Topics, "#new" do
	before(:each) do
	  @new_topic = mock(:topic)
	end

  it "should initialize @new_topic if logged in" do
    @new_topic = mock(:topic)
    @new_post = mock(:post)
    id_forum = {:forum_id => 1}
    params = {:topic => id_forum}
    Post.should_receive(:new).and_return(@new_post)
    Topic.should_receive(:new).and_return(@new_topic)
    dispatch_to(Topics, :new, params) do |controller|
      controller.stub!(:topic).and_return(nil)
      controller.should_receive(:logged_in?).and_return(true)
      controller.should_receive(:render)
    end
  end

end

describe Topics, "#create" do
  include TopicsSpecHelper
  
  before(:each) do
  @new_topic = mock(:topic)
  @new_post = mock(:post)
  @new_topic.stub!(:forum_id)
  Topic.should_receive(:new).and_return(@new_topic)
  Post.should_receive(:new).and_return(@new_post)
  topic_params = {:forum_id => 1, :name => "blah"}
  @params = {:topic => topic_params, :post => {:text => 'hi'}}
  end
  
  def do_topic(params={}, &block)
    dispatch_to(Topics, :create, @params) do |controller|
    controller.should_receive(:logged_in?).and_return(true)
    controller.stub!(:topic).and_return(nil)
    controller.stub!(:render)
    block.call(controller) if block_given?
    end
  end

  it "should save topic" do
    do_topic do |controller|
      @new_topic.stub!(:save).and_return(true)
      @new_topic.stub!(:id).and_return(1)
      @new_post.stub!(:topic_id=)
      @new_post.stub!(:save).and_return(true)
      controller.stub!(:redirect)
      controller.should_receive(:redirect)
    end
  end

  it "should not save topic if topic is not valid" do
    do_topic do |controller|
      @new_topic.stub!(:save).and_return(false)
    end
  end
  
  it "should not save topic if post is not valid" do
    do_topic do |controller|
      @new_topic.stub!(:save).and_return(true)
      @new_topic.stub!(:id).and_return(1)
      @new_post.stub!(:topic_id=)
      @new_post.stub!(:save).and_return(false)
    end
  end
end

describe Topics, "testing find_forum" do
include TopicsSpecHelper
  before(:each) do
    @forum = mock(:forum)
    Forum.stub!(:first).and_return(@forum)
  end
    
    def do_post(params={}, &block)
      dispatch_to(Topics, :new, params) do |controller|
        controller.should_receive(:logged_in?).and_return(true)
        controller.stub!(:topic_id)
        controller.stub!(:render)
        controller.should_receive(:render)
        block.call(controller) if block_given?
       end
    end
    
    it "should make a new topic" do
      @new_topic = mock(:topic)
      @forum.stub!(:id).and_return(1)
      @new_topic.stub!(:forum_id=)
      id_forum = {:id => 1}
      Topic.should_receive(:new).and_return(@new_topic)
      do_post do |controller|
        controller.stub!(:topic).and_return(nil)
        controller.assigns(:new_topic)
      end
    end
=begin
  it "should make a new post" do
    @new_post = mock(:post)
    @topic.stub!(:id).and_return(1)
    @new_post.stub!(:topic_id=)
    id_topic = {:id => 1}
    params = {:post => nil, :topic => id_topic}
    Post.should_receive(:new).and_return(@new_post)
    do_post do |controller|
      controller.stub!(:post).and_return(nil)
      controller.assigns(:new_post)
    end
  end
  
  it "should make a new post when topic_id isn't nil" do
    @post = mock(:post)
    params = {:post => valid_new_post}
    do_post do |controller|
      controller.stub!(:post).and_return(@post)
    end
  end

  it "should set forum_id if params:topic is not nil" do
  @topic = mock(:topic)
  @forum = mock(:forum)
  @new_topic = mock(:topic)
  @new_post = mock(:post)
  @new_topic.stub!(:forum_id)
  Forum.should_receive(:first).and_return(@forum)
  Topic.should_receive(:new).and_return(@new_topic)
  Post.should_receive(:new).and_return(@new_post)
  @params = {:post => {:text => 'hi'}, :topic => valid_new_topic}
    dispatch_to(Topics, :create, (@params)) do |controller|
      controller.should_receive(:logged_in?).and_return(true)
      controller.stub!(:topic).and_return(@topic)
      @new_topic.stub!(:save).and_return(false)
      controller.stub!(:render)
    end
  end
=end

end

describe Topics, "#create", "testing raise err for find forum" do
  it "should raise err 404 when forum.nil" do
    p 'starting test'
=begin
    class Topics < Application
      def create
        # overloaded so you don't need to test this particular
        # part of the controller, you want to isolate
        # the before filter
        'completed'
      end
    end
=end
    dispatch_to(Topics, :new, {:topic => {:forum_id => 1}})


    @forum = mock(:forum)
    @forum.stub!(:id).and_return(1)
      
    Forum.should_receive(:first).with(:id => 1).and_return(nil)
    params = {:topic => {:forum_id => 1}}
#    dispatch_to(Topics, :create, params)
    
    lambda { dispatch_to(Topics, :create, params) }.should raise_error(::Merb::ControllerExceptions::NotFound)
  end
end