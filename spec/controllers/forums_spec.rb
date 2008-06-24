require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Forums, '#new' do
  
  it 'should render action' do
    @forum = mock(:forum)
    #Forum.stub!(:first).and_return(@forum)
    #@forum.stub!(:id)
    dispatch_to(Forums, :index, {:id => 1}) do |controller|
      controller.stub!(:find_forum)
      #controller.should_receive(:find_forum)
      controller.stub!(:render)
      controller.should_receive(:render)
    end
  end
end

describe Forums, '#show' do
  
  it "should have @forum and @topics_page variables" do
    @forum = mock(:forum)
    @forum.stub!(:id=)
    Forum.should_receive(:first).with(:id => 1).and_return(@forum)
    dispatch_to(Forums, :show, {:id => 1}) do |controller|
      controller.assigns(:forum)
      #@forum.id.should == params
      controller.stub!(:render)
      controller.should_receive(:render)
    end
  end
end
