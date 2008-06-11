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
      dispatch_to(People, :new)
    end
    
  end
  
  describe "#create" do
    
    before(:each) do
      @params = {:user => '', :person => ''}
      @new_person = mock(:person)
      @new_user = mock(:user)
      Person.should_receive(:new).and_return(@new_person)
      User.should_receive(:new).and_return(@new_user)
    end
    
    it "should render #new if CAPTCHA is incorrect" do
      dispatch_to(People, :create, @params) do |controller|
        controller.should_receive(:verify_recaptcha).and_return(false)        
        controller.should_receive(:render).with(:new)
      end
    end
    

    
    describe "with valid models and correct CAPTCHA" do
      after(:each) do
        dispatch_to(People, :create, @params) do |controller|
          controller.should_receive(:verify_recaptcha).and_return(true)
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
      end
    end

    it "should render #new again if person is invalid in the before creation context" do
      @new_person.should_receive(:valid?).with(:before_user_creation).and_return(false)
      dispatch_to(People, :create, @params) do |controller|
        controller.should_receive(:verify_recaptcha).and_return(true)
        controller.should_receive(:render).with(:new)
      end
    end
    
  end
  
  describe "#index" do
  
    it "should pull up a paginated list of @people"
  
    it "should default order by id"
  
    it "should allow order by number of advisees"
    
    it "should allow order by full name"
    
    it "should allow search full names"
    
    it "should allow search by location"

    it "should allow filter by is_adviser"
    
    it "should allow filter by region"
    
    it "should allow filter by registered voters"
    
  end
  
  describe "#show" do
  
    it "should get data for @user by id or username"
  
    it "should get display an error message if user not found"
    
    it "should check privacy settings for the user"
    
    it "should display an error when privacy settings conflict"
    
  end
  
  describe "#edit" do
  
    it "should only work for the current user on their own person"
    
    it "should find @edit_user and @edit_person for id"
    
  end
  
  describe "#update" do
  
  end
  
  describe "#destroy" do
  
  end
end