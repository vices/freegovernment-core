require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "group_spec_helper")

describe Group, "in general"  do
	include GroupSpecHelper

  before(:each) do
    Group.auto_migrate!
		@group = Group.new
  end

	it "should require a name property" do
		@group.attributes = valid_new_group.except(:name)
		@group.should_not be_valid
	end

	it "should require a description property" do
		@group.attributes = valid_new_group.except(:description)
		@group.should_not be_valid
	end
end

describe Group, "upon creation" do
	include GroupSpecHelper
	
	before(:each) do
    Group.auto_migrate!
		@group = Group.new
  end
	
	it "should require a name property only between 4 and 20 chars" do
	(4..20).each do |num|
		@group.name = "a" * num
		@group.valid?
		@group.errors.on(:name).should be_nil
		end
	end
	
	it "should require a name property only between 4 and 500 chars" do
	(4..500).each do |num|
		@group.description = "a" * num
		@group.valid?
		@group.errors.on(:description).should be_nil
		end
	end
	
	it "should require the name only at creation" do
		@group.attributes = valid_new_group.except(:name)
		@group.valid?
		@group.errors.on(:name).should_not be_nil
		@group.errors.on(:name).should_not be_empty
		@group.name = "NRA"
		@group.save
		@group.description = "We want guns to be destributed to children too *wink*"
		@group.valid?
		@group.errors.on(:name).should be_nil
	end
end