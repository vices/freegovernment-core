require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "user_spec_helper")

describe User, "in general"  do
  include UserSpecHelper

  before(:each) do
    User.auto_migrate!
    @user = User.new
  end


  it "should require a username property" do
    @user.attributes = valid_new_user.except(:username)
    @user.should_not be_valid
  end

  it "should have a email property" do
    @user.attributes = valid_new_user.except(:email)
    @user.should_not be_valid
  end

  it "should have a crypted_password property"do
    @user.should respond_to(:crypted_password)
  end

  it "should have a salt property" do
    @user.should respond_to(:salt)
  end

  it "should have a password accessor" do
    @user.should respond_to(:password)
  end
  
  it "should have a password_confirmation accessor" do
    @user.should respond_to(:password)
  end
  
  it "should require a username only between 4 and 20 chars" do
    (4..20).each do |num|
      @user.username = "d" * num
      @user.valid?
      @user.errors.on(:username).should be_nil
    end
  end
  
    it "should require an email only between 8 and 40 chars" do
    (3..40).each do |num|
      @user.email = ("d" * num) + "@a.com"
      @user.valid?
      @user.errors.on(:email).should be_nil
    end
  end

  it "should require a real email" do
    @user.attributes = valid_new_user.except(:email)
    @user.email = 'foysavas_at_gmail.com'
    @user.valid?
    @user.errors.on(:email).should_not be_nil
    @user.email = 'foysavas.com'
    @user.valid?
    @user.errors.on(:email).should_not be_nil
  end
  

  it "should require a unique email" do
    @user.attributes = valid_new_user
    @user.save
    user2 = User.new(:valid_new_user)
    user2.valid?
    user2.errors.on(:email).should_not be_nil
  end
  
  it "should require a unique username" do
    @user.attributes = valid_new_user
    @user.save
    user2 = User.new(:valid_new_user)
    user2.valid?
    user2.errors.on(:username).should_not be_nil
  end

  it "should downcase username" do
    @user.attributes = valid_new_user
    @user.username = "Foysavas"
    @user.username.should == "foysavas"
  end

end

describe User, "upon creation" do
  include UserSpecHelper
  
  before(:each) do
    User.auto_migrate!
    @user = User.new
  end
    
  it "should set the salt" do
    @user.attributes = valid_new_user
    @user.salt.should be_nil
    @user.send(:encrypt_password)
    @user.salt.should_not be_nil
  end

  it "should require the password only at create" do
    @user.attributes = valid_new_user.except(:password)
    @user.valid?
    @user.errors.on(:password).should_not be_nil
    @user.errors.on(:password).should_not be_empty
    @user.password = 'password'
    @user.save
    @user.email = 'foy.savas@gmail.com'
    @user.valid?
    @user.errors.on(:password).should be_nil
  end

  it "should require password_confirmation upon create" do
    @user.attributes = valid_new_user.except(:password_confirmation)
    @user.valid?
    @user.errors.on(:password_confirmation).should_not be_nil
  end

  it "should require a password between 8 and 40 chars" do
    (8..40).each do |num|
      @user.password = "d" * num
      @user.password_confirmation = @user.password
      @user.valid?
      @user.errors.on(:password).should be_nil
    end
  end
end


describe User, "during authentication" do
  
  include UserSpecHelper
  
  before(:each) do
    User.auto_migrate!
    @user = User.new(valid_new_user)
    @user.save
  end

  it "should authenticate a user using a class method" do
    check = User.authenticate(valid_new_user[:username], valid_new_user[:password])
    check.should_not be_nil
    check.should == @user
  end
  
  it "should not authenticate a user using a wrong password" do
    User.authenticate(valid_new_user[:username], "wrong_password").should be_nil
  end

  it "should not authenticate a user using the wrong username" do
    user2 = User.new(valid_new_user.except(:username, :email, :password, :password_confirmation))
    user2.username = 'foysavas2'
    user2.email = 'foysavas2@gmail.com'
    user2.password = user2.password_confirmation = 'password2'
    user2.save
    User.authenticate('foysavas2', valid_new_user[:password]).should be_nil  
  end

  it "should not authenticate a user that does not exist" do
    User.authenticate('notme', valid_new_user[:password]).should be_nil  
  end

  it "should authenticate against a password" do
    @user.authenticated?(valid_new_user[:password]).should == true
  end

end
