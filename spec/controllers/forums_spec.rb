require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Forums do
  describe "#index" do
    before(:each) do
      @general_forums = [mock(:forum)]
      @group_forums = [mock(:forum)]
      @poll_forums = [mock(:forum)]
      Forum.stub!(:all).with(:group_id => nil, :poll_id => nil).and_return(@general_forums)
      Forum.stub!(:all).with(:group_id.not => nil).and_return(@group_forums)
      Forum.stub!(:all).with(:poll_id.not => nil).and_return(@poll_forums)
    end
  
    it "should create lists of general, group, and poll forums" do
      Forum.should_receive(:all).with(:group_id => nil, :poll_id => nil)
      #Forum.should_receive(:all).with(:group_id.not => nil)
      #Forum.should_receive(:all).with(:poll_id.not => nil)
      dispatch_to(Forums, :index)
    end
    
  end
  
  describe "#show" do
  
  end
end