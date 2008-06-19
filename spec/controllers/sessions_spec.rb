require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "user_spec_helper")


describe Session, "In general" do

=begin
  before(:each) do
 pp @foysavas = User.create(valid_new_user.merge({:id => '2', :username => "foysavas", :password => "rawfruit", :password_confirmation => "rawfruit"}))
  @controller = Session.new(fake_request)
  end
=end
  
  def do_it
    @controller = dispatch_to(Session, :create, {:username => @user.username, :password => @user.password})
  end
  
  
  before(:each) do
    @user = mock(User, :username => 'foysavas', :password => 'rawfruit')
    User.stub!(:authenticate).with(@user.username, @user.password).and_return(@user)
  end
  
  it "should redirect to home upon login" do
    do_it
    @controller.should redirect_to(:home)
  end

  
  it "should update the session" do
    do_it
    @controller.session[:user_id].should_not be_nil
    @controller.session[:user_id].should == @user.id
  end

end


describe Session, "failing to login" do
  before(:each) do
    @user = mock(User, :username => 'foysavas', :password => 'badpass')
    User.stub!(:authenticate).with(@user.username, @user.password).and_return(nil)
  end
   
  def do_it
    @controller = dispatch_to(Session, :create, {:username => @user.username, :password => @user.password})
  end
  
  it "should not redirect to home" do
    do_it
    @controller.should_not redirect_to(:home)
    #should be
    #@controller.should_not be_redirected
    #but undefined method `redirected?' for #<Session:0xb76733a8>
  end

  it "should not populate the session" do
    do_it
    @controller.session[:user_id].should be_nil
  end
  
  it "should have a success status code" do
    do_it
    @controller.should be_successful
    #should this be:
    #@controller.should_not be_succesful
  end

end

describe "#destroy" do

  it "logs out" do
    controller = dispatch_to(Session, :destroy) { | controller| controller.stub!(:current_user).and_return(@foysavas) }
    controller.session[:user_id].should be_nil
    controller.should redirect
  end

=begin
  it "should reset the session regardless of the user's login status" do
    user = @user
    user.stub!(:forget_me)
    dispatch_to(Session, :destroy) do |controller|
      controller.stub!(:current_user).and_return(user)
      controller.should_receive(:logged_in?).and_return(true)
      controller.cookies.should_receive(:reset_session)
    end
      
  end
=end

end