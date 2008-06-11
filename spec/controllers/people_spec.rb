require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe People do
  describe "#new" do
  
    before(:each) do
      #prep
      @new_person = mock(:person)
      @new_user = mock(:user)
    end
  
    it "should initialize @new_person and @new_user" do
      # what we need
      User.should_receive(:new).and_return(@new_user)
      Person.should_receive(:new).and_return(@new_person)
      # gets the controller to actually run the method
      dispatch_to(People, :new)
    end
    
    it "should display a CAPTCHA"
    
  end
  
  describe "#create" do
    it "should require a correct CAPTCHA"
    
    it "should render #new if CAPTCHA is incorrect"
    
    it "should create a new user and person when valid"
    
    it "should render #new again if user or person is invalid"
    
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