require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "person_spec_helper")
require File.join(File.dirname(__FILE__), "..", "user_spec_helper")

describe People do


  describe "#new" do

    before(:each) do
      @new_person = mock(:person)
      @new_user = mock(:user)
    end
  
    it "should initialize @new_person and @new_user" do
      User.should_receive(:new).and_return(@new_user)
      Person.should_receive(:new).and_return(@new_person)
      dispatch_to(People, :new) do |controller|
       controller.stub!(:render)
      end
    end
    
  end

  describe "#create" do
    
    before(:each) do
      @params = {:user => '', :person => ''}
      @new_person = mock(:person)
      @new_user = mock(:user)
      Person.should_receive(:new).and_return(@new_person)
      User.should_receive(:new).and_return(@new_user)
      # TODO: remove when DM is fixed
      @new_user.stub!(:valid?).and_return(true)
    end
    
    it "should render #new if CAPTCHA is incorrect" do
      dispatch_to(People, :create, @params) do |controller|
        controller.should_receive(:verify_recaptcha).and_return(false)        
        controller.should_receive(:render).with(:new)
        controller.stub!(:render)
      end
    end
    

    
    describe "with valid models and correct CAPTCHA" do
      after(:each) do
        dispatch_to(People, :create, @params) do |controller|
          controller.should_receive(:verify_recaptcha).and_return(true)
          controller.stub!(:render)
        end
      end

      it "should require a correct CAPTCHA" do
        @new_person.stub!(:valid?).and_return(false)
      end
      
      it "should create a new user and person when valid" do
      	@new_user.stub!(:id).and_return(1)
      	@new_person.stub!(:user_id=)
      	@new_user.stub!(:username)
      	@new_peson.stub!(:id).and_return(1)
      	@new_user.stub!(:person_id=)
        @new_person.should_receive(:valid?).and_return(true)
        @new_person.should_receive(:save)
        @new_user.should_receive(:save).twice.and_return(true)
      end
    end
    
    it "should render #new again if user is invalid" do    
      @new_person.should_receive(:valid?).with(:before_user_creation).and_return(true)
      @new_user.should_receive(:save).and_return(false)
      dispatch_to(People, :create, @params) do |controller|
        controller.should_receive(:verify_recaptcha).and_return(true)
        controller.should_receive(:render).with(:new)
        controller.stub!(:render)
      end
    end

    it "should render #new again if person is invalid in the before creation context" do
      @new_person.should_receive(:valid?).with(:before_user_creation).and_return(false)
      dispatch_to(People, :create, @params) do |controller|
        controller.should_receive(:verify_recaptcha).and_return(true)
        controller.should_receive(:render).with(:new)
        controller.stub!(:render)
      end
    end
    
  end
  
  describe "#index" do
      
    before(:each) do
      @person = mock(:person)
      @people_page = [@person]
    end

    def do_get(params = nil, &block)
      dispatch_to(People, :index, params) do |controller|
        controller.stub!(:render)
        block.call(controller) if block_given?
      end
    end

    it "should be successful" do
      do_get.should be_successful
    end

    it "should pull up a pages worth of people" do
      Person.stub!(:all).and_return(@people_page)
      Person.should_receive(:all).and_return(@people_page)
      do_get.assigns(:people_page).should == @people_page
    end

    it "should use sort_by and direction to construct order used in all" do
      sort_by = :id
      direction = :desc
      params = {:sort_by => sort_by, :direction => direction}
      operator = mock(:operator)
      DataMapper::Query::Operator.stub!(:new).with(sort_by,direction).and_return(operator)
      Person.should_receive(:all).with(:order => [operator]).twice
      do_get(params).assigns(:sort_by).should == sort_by
      do_get(params).assigns(:direction).should == "desc"
      
    end
    
    it "should default order by id" do
     do_get.assigns(:sort_by).should == :id
     do_get.assigns(:direction).should == "asc"
     
    end
    

  
    it "should allow order by number of advisees" do
			pending
  #    @advisee_count = #put advisee list into array and then join it 
  #    Person.should_receive(:all).with(:order=>[@advisee_count.asc]) #dsc?
  #    do_get
    end
    
    it "should allow order by full name" do
      do_get({:sort_by => 'name', :direction => 'asc'}).assigns(:sort_by).should == :full_name
      do_get({:sort_by => 'name', :direction => 'asc'}).assigns(:direction).should == "asc"    
    end
    
    it "should allow search full names"
    
    it "should allow search by location"

    it "should allow filter by is_adviser"
    
    it "should allow filter by region"
    
    it "should allow filter by registered voters"
    
  end
end

describe People, "#show" do
include UserSpecHelper
	before(:each) do
	  @person = mock(:person)
	  @user = User.new(valid_new_user)
	  User.stub!(:first).and_return(@user)
	  Person.stub!(:first).and_return(@person)
	end

  def do_get(params = {}, &block)
    dispatch_to(People, :show, {:id => 1 }.merge(params)) do |controller|
      controller.stub!(:render)
      block.call(controller) if block_given?
    end
  end
  
  it "should be successful" do
    do_get.should be_successful
    
  end  
  
#  it "should return not found if @person id does not exist" do
#    User.stub!(:first).and_return(nil)
#    dispatch_to(People, :show, {:id => 'noone'}) do |controller|
#      controller.should raise_error(Merb::ControllerExceptions::NotFound)
#    end
#  end
  
  it "should get data for @person by id" do
    User.should_receive(:first).and_return(@user)
    do_get
  end
  
  it "should get display an error message if user not found"
  
  it "should check privacy settings for the user"
  
  it "should display an error when privacy settings conflict"
  
end

describe People, "#edit" do

	before(:each) do
  	@user = mock(:user)
    @person = mock(:person)
    User.stub!(:first).and_return(@user)
    @user.stub!(:person).and_return(@person)
    @user.stub!(:id=)
	end
	
	def do_get(params={}, &block)
    dispatch_to(People, :edit, {:id => 'username'}) do |controller|
      controller.stub!(:session).and_return({:user_id => @user.id})
      controller.stub!(:render)
      block.call(controller) if block_given?
		end
	end
	
	it "should be successful" do
		do_get.should be_successful
	end

	it "should load the requested person" do
		do_get({:full_name => 'Easter Bunny'}) do
			assigns(:person).should == @person
		end
	end

	it "should render the action" do
    do_get do |controller|
      controller.should_receive(:render)
    end
	end
end

describe People, "#update" do
  include UserSpecHelper
  include PersonSpecHelper

  it "should set the attributes" do
   @user = mock(:user)
   @person = mock(:person)
   User.stub!(:first).and_return(@user)
   @user.stub!(:person).and_return(@person)
   @user.stub!(:id)
   @user.stub!(:username)
   
    params = {:user => User.new(valid_new_user), :person => Person.new(valid_new_person)}
    
    dispatch_to(People, :update, params) do |controller|
      controller.stub!(:session).and_return({:user_id => @user.id})
      @user.should_receive(:update_attributes).and_return(true)
      @person.should_receive(:update_attributes).and_return(true)
      controller.stub!(:render)
    end
  end
  
=begin
  dispatch_to(People, :update, params) do |controller|
    controller.stub!(:session).and_return({:user_id => 1})
    controller.stub!(:user).and_return(nil)
    controller.stub!(:avatar).and_return(nil)
    controller.stub!(:save).and_return(true)    
    @user.should_receive(:attributes=).and_return(@user)
    @user.should_receive(:avatar=)
    @user.stub!(:username)
    @user.should_receive(:save).and_return(true)
  end
=end

end