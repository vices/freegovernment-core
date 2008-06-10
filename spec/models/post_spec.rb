require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "post_spec_helper")

describe Post, "in general"  do
  include PostSpecHelper
  
  before(:each) do
    Post.auto_migrate!
    @post = Post.new
  end
  
  it "should require a text property" do
    @post.attributes = valid_new_post.except(:text)
    @post.should_not be_valid
  end
  
  it "should require a user id property" do
    @post.attributes = valid_new_post.except(:user_id)
    @post.should_not be_valid
  end
  
  it "should require a forum id property" do
    @post.attributes = valid_new_post.except(:forum_id)
    @post.should_not be_valid
  end
  
  it "should require a topic id property" do
    @post.attributes = valid_new_post.except(:topic_id)
    @post.should_not be_valid
  end
  
  it "should require a parent id property" do
    @post.attributes = valid_new_post.except(:parent_id)
    @post.should_not be_valid
  end
  

end

describe Post, "upon creation" do

  include PostSpecHelper

  before(:each) do
    Post.auto_migrate!
    @post = Post.new(valid_new_post)
    @post.save
  end

  it "should record created at" do
    @post.created_at.should_not be_nil
    @post.created_at.class.should == DateTime
  end

  it "should record updated at" do
    @post.updated_at.should_not be_nil
    @post.updated_at.class.should == DateTime
  end

  it "should have a text between 1 and 100 chars" do
    (1..100).each do |num|
      @post.text = "a" * num #if you are going to set a minimum, make sure this will take that into account
      @post.valid?
      @post.errors.on(:text).should be_nil
    end
  end

end