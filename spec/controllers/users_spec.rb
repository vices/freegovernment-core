require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "user_spec_helper")


describe Users, "#update" do
  include UserSpecHelper

it "should set the @user attributes if they are nil" do
   @user = mock(:user)
   User.stub!(:first).and_return(@user)
   @user.stub!(:id=)
   @avatar = mock(:avatar)

  params = {:user => nil, :avatar => nil}

  dispatch_to(Users, :update, params) do |controller|
    controller.stub!(:session).and_return({:user_id => @user.id})
    controller.stub!(:user).and_return(nil)
    controller.stub!(:avatar).and_return(nil)
    controller.stub!(:save).and_return(true)    
    @user.should_receive(:attributes=).and_return(@user)
    @user.should_receive(:avatar=)
    @user.stub!(:username)
    @user.should_receive(:save).and_return(true)
  end
end

it "should render :edit if paramters aren't nil" do
  @user = mock(:user)
  User.stub!(:first).and_return(@user)
  @user.stub!(:id=)
  @avatar = mock(:avatar)
  params = {:user => valid_new_user, :avatar => valid_new_user}
  
  dispatch_to(Users, :update, params) do |controller|
    controller.stub!(:session).and_return({:user_id => @user.id})
    @user.should_receive(:attributes=).and_return(@user)
    @user.should_receive(:avatar=).and_return(@avatar)
    @user.should_receive(:save).and_return(false)
    @user.stub!(:username)
    @user.stub!(:avatar)
  end
end

=begin
it "should render :edit if @user attributes aren't nil" do
   @user = User.new(valid_new_user.merge(:user_id => 1))
   User.stub!(:first).and_return(@user)
   @user.stub!(:id=)
   @avatar = mock(:avatar)
   #@user.stub!(:attributes).with(valid_new_user)
  #params = {:user => nil, :avatar => nil}
    params = {:user => User.new(valid_new_user), :avatar => 'soeval'}

    dispatch_to(Users, :update, params) do |controller|
      controller.stub!(:session).and_return({:user_id => 1})
      @user.stub!(:attributes).with(valid_new_user)   
      controller.stub!(:user).and_return(@user)
      #controller.stub!(:avatar).with('someval')
      #controller.assigns(:avatar).stub!().with('someval')
      #controller.assigns(:avatar).should == 'someval'
      #controller.stub!(:user).and_return(@user)
      #controller.stub!(:avatar).and_return(@avatar)
      #controller.stub!(:save).and_return(false)
      #@user.should_not_receive(:attributes=).and_return(@user)
      #@user.should_not_receive(:avatar=)
      ##@user.stub!(:username)
      #@user.should_receive(:save).and_return(true)
      #controller.should_receive(:render).with(:edit)
      end
end
=end
end
describe Users, "#edit" do

  it 'should render action' do
  	@user = mock(:user)
    User.stub!(:first).and_return(@user)
    @user.stub!(:id=)
    dispatch_to(Users, :edit, {:id => "username"}) do |controller|
      controller.stub!(:session).and_return({:user_id => @user.id})
      controller.stub!(:render)
      controller.should_receive(:render)
    end
  end
end