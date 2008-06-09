require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "topic_spec_helper")


describe Topic, "in general"  do
  include TopicSpecHelper
  
  before(:each) do
    Topic.auto_migrate!
    @topic = Topic.new
  end
  
  it "should require a name property" do
    @topic.attributes = valid_new_topic.except(:name)
    @topic.should_not be_valid
  end
  
  it "should require a user id property" do
    @topic.attributes = valid_new_topic.except(:user_id)
    @topic.should_not be_valid
  end

  it "should require a forum id property" do
    @topic.attributes = valid_new_topic.except(:forum_id)
    @topic.should_not be_valid
  end

end

describe Topic, "upon creation" do

  include TopicSpecHelper

  before(:each) do
    Topic.auto_migrate!
    @topic = Topic.new(valid_new_topic)
    @topic.save
  end

  it "should record created at" do
    @topic.created_at.should_not be_nil
    @topic.created_at.class.should == DateTime
  end

  it "should record updated at" do
    @topic.updated_at.should_not be_nil
    @topic.updated_at.class.should == DateTime
  end

  it "should require a name property only between 3 and 100 chars" do
   (3..100).each do |num|
     @topic.name = "a" * num
     @topic.valid?
     @topic.errors.on(:name).should be_nil
    end
  end

end