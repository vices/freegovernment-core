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
    controller.stub!(:session).and_return({:user_id => 1})
    controller.stub!(:user).and_return(nil)
    controller.stub!(:avatar).and_return(nil)
    controller.stub!(:save).and_return(true)    
    @user.should_receive(:attributes=).and_return(@user)
    @user.should_receive(:avatar=)
    @user.stub!(:username)
    @user.should_receive(:save).and_return(true)
  end
end
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