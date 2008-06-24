require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "topics_spec_helper")


describe Topics, "#new" do
	before(:each) do
	  @new_topic = mock(:topic)
	end

  it "should initialize @new_topic if logged in" do
		Topic.should_receive(:new).and_return(@new_topic)
		dispatch_to(Topics, :new) do |controller|
		   controller.stub!(:logged_in?).and_return(true)
       controller.stub!(:render) #TODO is this used?
    end
  end

end

describe Topics, "#create", "when not logged on" do
  include TopicsSpecHelper

  it "should not save topic" do
    dispatch_to(Topics, :create, {:topic => valid_new_topic}) do |controller|
      controller.should_receive(:logged_in?).and_return(false)
      @new_topic.should_not_receive(:save)
    end
  end
end

describe Topics, "#create", "valid topic" do

  it "should show already existing matching poll questions during form completion" #and they should be hyperlinked

  it "should render poll when saved" do
    def do_get(params={}) 
    #does the following line do anything at all? it works without it
    #it also works if return(true) or return(false)
    #@new_poll.should_receive(:save).and_return(true)
      dispatch_to(Polls, :show, {:id => "1"}.update(params)) do |controller|
        controller.should_receive(:display).with(@poll)
        controller.stub!(:display)
      end
    end
  end
 
end


describe Topics, "#create" do

end

describe Topics, "#index" do

end

describe Topics, "#show" do

end