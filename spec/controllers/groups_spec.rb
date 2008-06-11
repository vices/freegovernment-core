require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Groups do
  decribe "#new" do
    it "should initialize @new_group"
    
    it "should display a CAPTCHA"
    
  end
  
  describe "#create" do
    it "should require a correct CAPTCHA"
    
    it "should render #new if CAPTCHA is incorrect"
    
    it "should create a new user and group when valid"
    
    it "should render #new again if user or group is invalid"
    
  end
  
  describe "#index" do
  
    it "should pull up a paginated list of @groups"
  
    it "should default order by id"
  
    it "should allow order by number of advisees"
    
    it "should allow order by name"
    
    it "should allow search names"
    
    it "should allow search by location"

    it "should allow filter by is_adviser"
    
    it "should allow filter by region"
    
    it "should allow filter by registered voters"
    
  end
  
  describe "#show" do
  
    it "should get data for @group by id or name"
  
    it "should get display an error message if group not found"
    
    it "should check privacy settings for the group"
    
    it "should display an error when privacy settings conflict"
    
  end
  
  descibe "#edit" do
  
    it "should only work for the current group on their own person"
    
    it "should find @edit_group for id"
    
    
  
  end
  
  describe "#update" do
  
  end
  
  describe "#destroy" do
  
  end
end