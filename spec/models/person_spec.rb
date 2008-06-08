require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "person_spec_helper")


describe Person, "in general"  do
  include PersonSpecHelper
  
  before(:each) do
    Person.auto_migrate!
    @person = Person.new
  end

  it "should require a full name property" do
    @person.attributes = valid_new_person.except(:full_name)
    @person.should_not be_valid
  end
  
  it "should require a date of birth property" do
    @person.attributes = valid_new_person.except(:date_of_birth)
    @person.should_not be_valid
  end
  
  it "should allow for description property" do
    @person.should respond_to(:description)
  end
end


describe Person, "upon creation" do

end

