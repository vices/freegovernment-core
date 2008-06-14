require File.join(File.dirname(__FILE__), "..", "spec_helper")

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
        @new_person.should_receive(:valid?).and_return(true)
        @new_user.should_receive(:save).and_return(true)
        @new_person.should_receive(:save)
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
        block if block_given?
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
      Person.should_receive(:all).with(:order => [operator])
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
    

  
    it "should allow order by number of advisees" do
			pending
  #    @advisee_count = #put advisee list into array and then join it 
  #    Person.should_receive(:all).with(:order=>[@advisee_count.asc]) #dsc?
  #    do_get
    end
    
    it "should allow order by full name" do
      do_get({:sort_by => 'name', :direction => 'asc'}) do
        assigns(:sort_by).should == :name
        assigns(:direction).should == :asc
      end
    end
    
    it "should allow search full names"
    
    it "should allow search by location"

    it "should allow filter by is_adviser"
    
    it "should allow filter by region"
    
    it "should allow filter by registered voters"
    
  end

  describe "#show" do
  
  	before(:each) do
  	@person = mock(:person)
  	Person.stub!(:first).and_return(@person)
  	end
  
    def do_get(params = {}, &block)
      dispatch_to(People, :show, {:id => 1 }.merge(params)) do |controller|
        controller.stub!(:render)
        block if block_given?
      end
    end
  
    it "should get data for @person by id" do
      do_get({:id => 1})  do
        assign(:person).should == @person
      end
    end
    
    it "should get display an error message if user not found"
    
    it "should check privacy settings for the user"
    
    it "should display an error when privacy settings conflict"
    
  end
  
  describe "#edit" do
  before(:each) do
  	@person = mock(:person)
  	@people_page = [@person]
  	Person.stub!(:first).and_return(@person)
  end
  
    def do_get(params = {}, &block)
      dispatch_to(People, :edit, {:id => 1 }.merge(params)) do |controller|
        controller.stub!(:render)
        block if block_given?
      end
    end
    
    it "should be successful" do
      do_get.should be_successful
    end
    
    it "should load the requested person" do
      do_get({:id => 1})  do
        assign(:person).should == @person
      end
    end
    
    it "should render the action" do
      dispatch_to(People, :edit, :id => "1") do |controller|
        controller.should_receive(:render)
      end
    end
    it "should only work for the current user on their own person"
    
    it "should find @edit_user and @edit_person for id"
    
  end
  
  describe "#show" do

  before(:each) do
  	@person = mock(:person)
  	Person.stub!(:first).and_return(@person)
  end
  
    def do_get(params = {}, &block)
      dispatch_to(People, :show, {:id => 1 }.merge(params)) do |controller|
        controller.stub!(:render)
        block if block_given?
      end
    end
    
      it "should load the requested page by the specificed slug" do #wtf is slug
        Person.should_receive(:by_slug_and_select_version!).and_return(@person)
        do_get.assign(:people_page).should == @person
      end
      
      it "should raise NotFound if a person cannot be found with slug" do
        Person.should_receive(:by_slug_and_select_version!).and_return(nil)
        lambda { do_get }.should raise_error(Merb::ControllerExceptions::NotFound)
      end
      #TODO foy look at the above todo
      it "should display the Person" do
    		dispatch_to(Person, :show, :user_id => "1") do |controller|
          controller.should_receive(:display).with(@person)
        end
      end
      
    end
  
  describe "#update" do
  
  end
  
  describe "#destroy" do
  #TODO nothing to see here
  end
end


