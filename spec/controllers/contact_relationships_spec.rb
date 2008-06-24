require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "contact_relationships_spec_helper")
  
describe ContactRelationship, "in general" do
include ContactRelationshipsSpecHelper
 
  before(:each) do
  ContactRelationship.auto_migrate!
  @relationship = ContactRelationship.new
  end

  it "should require an user id property" do
  @relationship.attributes = valid_new_relationship.except(:user_id)
  @relationship.should_not be_valid
  end
  it"should require an contact_id property" do
  @relationship.attributes = valid_new_relationship.except(:contact_id)
  @relationship.should_not be_valid
  end
  
  it"should require is_accepted property" do
  @relationship.attributes = valid_new_relationship.except(:is_accepted)
  @relationship.should_not be_valid
  end
  
  it"should respond to created_at property" do
  @relationship.should respond_to(:created_at)
  end
  
  it"should respond to modified_at property" do
  @relationship.should respond_to(:modified_at)
  end

end