require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "tag_spec_helper")
require File.join(File.dirname(__FILE__), "..", "poll_spec_helper")


describe Tag, "in general"  do
  include TagSpecHelper  
  
  before(:each) do
    Tag.auto_migrate!
    @tag = Tag.new
  end

  it "should require a name property" do
    @tag.attributes = valid_new_tag.except(:name)
    @tag.should_not be_valid
  end
  
  it "should respond to a permalink" do
    @tag.should respond_to(:permalink)
  end
end

describe Tag, "Getting polls with the tag" do
  include TagSpecHelper
  
  before(:each) do
  end
  
  
  it "should get all the polls in tagging map" do
  
  end
 
end


describe Tag, "When created" do
  include TagSpecHelper
  before(:each) do
    Tag.auto_migrate!
    @tag = Tag.new
  end

  it "should downcase the name  in the permalink when created" do
    @tag.name = "POCHICKEN"
    @tag.create
    @tag.permalink.should == "pochicken"
  end

  it "should strip out non letters and numbers" do
    @tag.name = '#$%!=`#/jo3anot#93;a\'[{]##'
    @tag.create
    @tag.permalink.should == "jo3anot93a"
  end

end


  
describe Tag, "#poll tags" do 
  include PollSpecHelper 
  include TagSpecHelper
  before(:each) do 
    Poll.auto_migrate! 
    Tag.auto_migrate!
    @poll = Poll.new 
    @tag = Tag.new
  end
  
  it "should just plain work" do
    @poll.attributes = valid_new_poll.merge(:id => 1, :tag_list => "osf, george")
    @tag.create_poll_tags(@poll)
  end
  #and now we test it
  
  it "should not fail at all" do
    @poll.attributes = valid_new_poll.merge(:id => 1, :tag_list => "pie, fruit")
    
    Tag.should_receive(:first)
    
    
    @tag.create_poll_tags(@poll)
  end
  
  it "should collect the tag_list from the user" #<-view
  
  it "should reject the poll tag list if it is nil/empty"
  
  it "should clear the poll tag list for remaking"
  
  it "should split the tag list into individual words"
  
  it "it should check each word in Tag where poll_id matches"
  
  it "should create the tag when not found"
  
  it "should add the tag and poll_id to the tagging map"
  
=begin
#instance_variable_set("@order_conditions", {:order => [:full_name.desc]})
  it "should search for a tag from the tag_list" do
    @tag.attributes = valid_new_tag.merge(:tag_list => "osf")
    pp @tag.tag_list
    #@poll.instance_variable_set("@tag_list", "five")
    Tag.should_receive(:first)#.with(:name => "osf")
    @tag.create_tags
  end
 =end
  
  it "should create a tag if it is not found" do
    @poll.attributes = valid_new_poll.merge(:tag_list => "osfive")
    Tag.should_receive(:create).with(:name => "osfive")
    @poll.create_tags
  end

  it "should create taggings for poll_id and tag_id" do
    @poll.tag_list = "five"
    @poll.stub!(:id).and_return(1) 
    Tagging.should_receive(:create).with(:poll_id => 1, :tag_id => 1).and_return(@new_tagging)
    @poll.create_tags
  end
  #    taggings.collect{ |tagging| tagging.tag.name }.join(", ")
  
  it "should get the tagging text with tags_text" do
    #@poll.stub!(:taggings).and_return("five")
    
    @poll.taggings.should_receive(:collect)
    pp @poll.tags
    #pp @poll.tags_text
  end

  
=begin  
  it "should search for a tag from the tag_list"  do
    #Tag.stub!(:first).with(nil)
    #@poll = mock(:poll) # this need to actually be the poll which is defined in the before for this describe
    #@poll.stub!(:create_tags)

    @poll.attributes = valid_new_poll
    @poll.stub!(:tag_list=).and_return("osf")
    @tag = mock(:tag)
    Tag.should_receive(:first).and_return(@tag)
    @tag.create_tags
  end

=begin
      Vote.stub!(:first).with(:poll_id => valid_new_vote[:poll_id], :user_id => controller.session[:user_id]).and_return(@old_vote)
      Vote.should_receive(:first).with(:user_id => controller.session[:user_id], :poll_id 
      => valid_new_vote[:poll_id]).and_return(@old_vote)
 =end

  it "should search for a tag from the :tag_list" do
    @poll.attributes = valid_new_poll.merge(:tag_list => "osf")
    Tag.should_receive(:first).with(:name => "osf")
    @poll.create_tags
  end

  it "should create a tag if it is not found" do
    @poll.attributes = valid_new_poll.merge(:tag_list => "osfive")
    Tag.should_receive(:create).with(:name => "osfive")
    @poll.create_tags
  end
  
  it "should create taggings for poll_id and tag_id" do
    @poll.tag_list = "five"
    @poll.stub!(:id).and_return(1) 
    Tagging.should_receive(:create).with(:poll_id => 1, :tag_id => 1).and_return(@new_tagging)
    @poll.create_tags
  end
  #    taggings.collect{ |tagging| tagging.tag.name }.join(", ")
  
  it "should get the tagging text with tags_text" do
    #@poll.stub!(:taggings).and_return("five")
    
    @poll.taggings.should_receive(:collect)
    pp @poll.tags
    #pp @poll.tags_text

=end

end
