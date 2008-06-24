require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "post_spec_helper")

describe Posts, '#show' do 
  
  it "should render action" do
    dispatch_to(Posts, :show) do |controller|
      controller.stub!(:render)
      controller.should_receive(:render)
    end
  end
end

describe Posts, "#new" do
include PostSpecHelper
  
  before(:each) do
    @topic = mock(:topic)
    Topic.stub!(:first).and_return(@topic)
  end
  
  def do_post(params={}, &block)
   dispatch_to(Posts, :new, params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:topic_id)
      controller.stub!(:render)
      controller.should_receive(:render)
      block.call(controller) if block_given?
    end
  end
  
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
end

describe Posts, "#create" do
  
  before(:each) do
    @new_post = mock(:post)
    @topic = mock(:topic)
    Topic.stub!(:first).and_return(@topic)
    @topic.stub!(:id).and_return(1)
    @new_post.stub!(:topic_id=)
    Post.should_receive(:new).and_return(@new_post)
    id_topic = {:id => 1}
    @params = {:post => {:text => 'hi'}, :topic => id_topic}
  end
  
  def do_post(params={}, &block)
    dispatch_to(Posts, :create, @params) do |controller|
      controller.stub!(:logged_in?).and_return(true)
      controller.stub!(:post).and_return(nil)
      controller.assigns(:new_post)
      block.call(controller) if block_given?
    end
  end
  
  it "should render :new if @new_post isn't saved" do
    do_post do |controller|
      @new_post.stub!(:save).and_return(false)
      controller.stub!(:render).with(:new)
      controller.should_receive(:render).with(:new)
    end
  end
  
  it "should render :new if @new_post when save is true" do
    do_post do |controller|
      @new_post.stub!(:save).and_return(true)
      controller.stub!(:redirect)
      controller.should_receive(:redirect)
    end
  end
  
end