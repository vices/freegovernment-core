require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "forum_spec_helper")



describe Forum, "in general" do
  include ForumSpecHelper
  
  before(:each) do
  Forum.auto_migrate!
  @forum = Forum.new
  end


  it "should require name" do
  @forum.attributes = valid_new_forum.except(:name)
  @forum.should_not be_valid
  end
  
  it "should require poll_id" do
  @forum.attributes = valid_new_forum.except(:poll_id)
  @forum.should_not be_valid
  end
  
  it "should respond to group_id" do
  @forum.should respond_to(:group_id)
  end
  
  it "should respond to topics_count" do
  @forum.should respond_to(:topics_count)
  end
  
  it "should respond to posts_count" do
  @forum.should respond_to(:posts_count)
  end
  
end

describe Forum, "upon creation" do
  include ForumSpecHelper

  before(:each) do
  Forum.auto_migrate!
  @forum = Forum.new(valid_new_forum)
  @forum.save
  end


  it "should default to topic count of zero" do
     @forum.topics_count.should == 0
     
   end
  it "should default to post count of zero" do
     @forum.posts_count.should == 0
    
  end
  
  it "should have a name field between 1 and 50 chars" do
    (1..50).each do |num|
      @forum.name = "a" * num
      @forum.valid?
      @forum.errors.on(:name).should be_nil
    end
  end
  
  it "should record created at" do
  @forum.created_at.should_not be_nil
  @forum.created_at.class.should == DateTime
  end
  
  it "should record updated at" do
  @forum.updated_at.should_not be_nil
  @forum.updated_at.class.should == DateTime
  end
  
  
end


