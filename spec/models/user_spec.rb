require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "user_spec_helper")

describe User, "in general"  do
  include UserSpecHelper

  before(:each) do
    User.clear_database_table
  end

  it "should have a username property"

  it "should have a email property"

  it "should have a crypted_password property"

  it "should have a salt property"

  it "should have a password accessor"

  it "should have a password_confirmation accessor"

  it "should require a username only betwen 3 and 40 chars"

  it "should require a unique username"

  it "should downcase username"

  it "should require an email"

end

describe User, "upon creation" do

  it "should have a protected password_required method"

  it "should require password if password is required"

  it "should set the salt"

  it "should require the password on create"

  it "should require password_confirmation if the password_required?"

  it "should require a password between 4 and 40 chars"

  it "should not require a password when saving an existing user"

end


describe User, "during authentication" do
  
  before(:each) do
    User.clear_database_table
  end

  it "should authenticate a user using a class method"
    
  it "should not authenticate a user using a wrong password"

  it "should not authenticate a user using the wrong username"

  it "should not authenticate a user that does not exist"

  it "should authenticate against a password"

end

