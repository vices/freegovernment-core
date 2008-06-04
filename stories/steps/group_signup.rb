@valid_new_group = { 'name' => 'Foy Savas Group', 'email' => 'foysavas@gmail.com', }
@valid_new_user = { 'username' => 'foygrosavas', 'password' => 'password', 'password_confirmation' => 'password' } 

steps_for(:group_signup) do

  When "I signup with invalid data" do
    @controller = post(url(:groups, :format => @request_format), { :user => @valid_new_user.delete('name'), :group => @valid_new_group })
  end
  
  When "I signup with valid data" do
    @controller = post(url(:groups, :format => @request_format), { :user => @valid_new_user, :group => @valid_new_group })
  end


end