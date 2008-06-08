require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "user_spec_helper")

describe User, "in general"  do
  include UserSpecHelper

  before(:each) do
    User.auto_migrate!
    @user = User.new
  end


  it "should require a user_id property" do
    @user.attributes = valid_new_user.except(:username)
    @user.should_not be_valid
  end

  it "should have a email property" do
    @user.attributes = valid_new_user.except(:email)
    @user.should_not be_valid
  end
  
  it "should have a crypted_password property"do
    @user.attributes = valid_new_user.except(:crypted_password)
    @user.should_not be_valid
  end

  it "should have a salt property" do
    @user.attributes = valid_new_user.except(:salt)
    @user.should_not be_valid
  end

  it "should have a password accessor" do
    @user.attributes = valid_new_user.except(:password)
    @user.should_not be_valid
  end
  
  it "should have a password_confirmation accessor" do
    @user.attributes = valid_new_user.except(:password_confirmation)
    @user.should_not be_valid
  end
  
  it "should require a username only between 3 and 40 chars" do
    (3..40).each do |num|
      @user.username = "d" * num
      @user.valid?
      @user.errors.on(:username).should be_nil
    end
  end
  
  it "should require a unique email"
  
=begin  it "should require a unique username" do
    user = User.new(valid_new_user)
    user2 = User.new(valid_new_user)
    user = {:username => "Foysavas"}
    user2 = {:username => "Foysavas"}
    user.save.should be_true
    user.username = "Foysavas"
    user2.save.should be_false
    user2.errors.on(:username).should_not be_nil
  end
=end

=begin  it "should downcase username" do
    @user.attributes_set(:username => "Foysavas")
    @user.username.should == "foysavas"
  
  end
=end
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
    User.auto_migrate!
  end

  it "should authenticate a user using a class method"
    
  it "should not authenticate a user using a wrong password"

  it "should not authenticate a user using the wrong username"

  it "should not authenticate a user that does not exist"

  it "should authenticate against a password"

end

