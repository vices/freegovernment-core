require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Groups, "#new" do
  
  before(:each) do
    @new_group = mock(:group)
    @new_user = mock(:user)
  end
  
  it "should initialize @new_person and @new_user" do
    User.should_receive(:new).and_return(@new_user)
    Group.should_receive(:new).and_return(@new_group)
    dispatch_to(Groups, :new) do |controller|
      controller.stub!(:render) 
    end
  end
  
  it "should display a CAPTCHA"
  
end
  
describe Groups, "#create" do
	before(:each) do
    @params = {:user => '', :group => ''}
    @new_group = mock(:group)
    @new_user = mock(:user)
    Group.should_receive(:new).and_return(@new_group)
    User.should_receive(:new).and_return(@new_user)
    # TODO: remove when DM is fixed
    @new_user.stub!(:valid?).and_return(true)
  end
  
  it "should render #new if CAPTCHA is incorrect" do
    dispatch_to(Groups, :create, @params) do |controller|
      controller.should_receive(:verify_recaptcha).and_return(false)        
      controller.should_receive(:render).with(:new)
      controller.stub!(:render)
    end
  end
    
  describe "with valid models and correct CAPTCHA" do
    after(:each) do
      dispatch_to(Groups, :create, @params) do |controller|
        controller.should_receive(:verify_recaptcha).and_return(true)
        controller.stub!(:render)
      end
    end

    it "should require a correct CAPTCHA" do
      @new_group.stub!(:valid?).and_return(false)
    end
    
    it "should create a new group and user when valid" do
    	@new_group.stub!(:id).and_return(1)
    	@new_user.stub!(:group_id=)
      @new_group.should_receive(:valid?).and_return(true)
   		@new_group.should_receive(:save)
      @new_user.should_receive(:save).twice.and_return(true)
    end
    
  end
  
  it "should render #new again if user is invalid" do    
    @new_group.should_receive(:valid?).with(:before_user_creation).and_return(true)
    @new_user.should_receive(:save).and_return(false)
    dispatch_to(Groups, :create, @params) do |controller|
      controller.should_receive(:verify_recaptcha).and_return(true)
      controller.should_receive(:render).with(:new)
      controller.stub!(:render)
    end
  end

  it "should render #new again if person is invalid in the before creation context" do
    @new_group.should_receive(:valid?).with(:before_user_creation).and_return(false)
    dispatch_to(Groups, :create, @params) do |controller|
      controller.should_receive(:verify_recaptcha).and_return(true)
      controller.should_receive(:render).with(:new)
      controller.stub!(:render)
    end
  end
end
  
describe Groups, "#index" do

  before(:each) do
    @group = mock(:group)
    @groups_page = [@group]
  end
  
  def do_get(params = nil, &block)
    dispatch_to(Groups, :index, params) do |controller|
      controller.stub!(:render)
      block if block_given?
    end
  end

  it "should pull up a pages worth of groups" do
    Group.stub!(:all).and_return(@groups_page)
    Group.should_receive(:all).and_return(@groups_page)
    do_get.assigns(:groups_page).should == @groups_page
  end

  it "should use sort_by and direction to construct order used in all" do
    sort_by = :id
    direction = :desc
    params = {:sort_by => sort_by, :direction => direction}
    operator = mock(:operator)
    DataMapper::Query::Operator.stub!(:new).with(sort_by,direction).and_return(operator)
    Group.should_receive(:all).with(:order => [operator])
    do_get(params) do
      assigns(:sort_by).should == sort_by
      assigns(:direction).should == direction
    end
  end

  it "should default order by id" do
    do_get do
      assigns(:sort_by).should == :id
      assigns(:direction).should == :asc
    end
  end

  it "should allow order by number of advisees"
  
  it "should allow order by name" do
    do_get({:sort_by => 'name', :direction => 'asc'}) do
      assigns(:sort_by).should == :name
      assigns(:direction).should == :asc
    end
  end
  
  it "should allow search names"
  
  it "should allow search by location"

  it "should allow filter by is_adviser"
  
  it "should allow filter by region"
  
  it "should allow filter by registered voters"
  
end
  
describe Groups, "#show" do

  before(:each) do
    @user = mock(:user)
    @group = mock(:group)
    User.stub!(:first).and_return(@user)
    @user.stub!(:group).and_return(@group)
  end


  def do_get(params={}, &block)
    dispatch_to(Groups, :show, {:id => 'groupusername'}) do |controller|
      controller.stub!(:render)
      block if block_given?
    end
  end

  it "should be successful" do
    do_get.should be_successful
  end

  it "should get data for @group by id" do

    do_get.assigns(:group).should == @group
    
  end
    
   it "should get data for @group by name" do
     do_get({:name => 'NRA'}) do
       assign(:group).should == @group
     end
   end
    
#   it "should get display an error message if group not found" do #this doesn't work too
#			Groups.should_receive(:first).and_return(nil)
#      do_get.should raise_error(Merb::ControllerExceptions::NotFound)
#   end
    
    it "should check privacy settings for the group"
    
    it "should display an error when privacy settings conflict"    

end

describe Groups, "#edit" do

  before(:each) do
    @group = mock(:group)
  end
  
  def do_get(params={}, &block)
    dispatch_to(Groups, :edit, {:id => 'groupusername'}) do |controller|
    	controller.should_receive(:find_group)
      controller.stub!(:render)
      block if block_given?
    end
  end
  
 
  it "should be successful" do
    do_get.should be_successful
  end
 
  it "should load the requested group" do
     do_get({:name => 'NRA'}) do
       assign(:group).should == @group
     end
  end
  
  it "should render the action" do
    do_get({:id => 'groupusername'}) do |controller|
      controller.should_receive(:render)
    end
  end
end

describe Groups, "#update" do

end

describe Groups, "#destroy" do

end