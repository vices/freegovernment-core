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
  include PersonSpecHelper
  
  before(:each) do
    Person.auto_migrate!
    @person = Person.new
  end
  
  
  it "should require a full name property only between 1 and 100 chars" do
    (1..100).each do |num|
      @person.full_name = "a" * num
      @person.valid?
      @person.errors.on(:full_name).should be_nil
      end
  end

  it "should require the full name only at create" do
    @person.attributes = valid_new_person.except(:full_name)
    @person.valid?
    @person.errors.on(:full_name).should_not be_nil
    @person.errors.on(:full_name).should_not be_empty
    @person.full_name = 'Foy Savas'
    @person.save
    @person.description = 'description joy dove luck'
    @person.valid?
    @person.errors.on(:full_name).should be_nil
  end 
  
  it "should require the date of birth only at create" do
  @person.attributes = valid_new_person.except(:date_of_birth)
  @person.valid?
  @person.errors.on(:date_of_birth).should_not be_nil
  @person.errors.on(:date_of_birth).should_not be_empty
  @person.date_of_birth = '1991-03-10'
  @person.save
  end
end
